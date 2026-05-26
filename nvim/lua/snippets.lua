local cmp = require('cmp')
local luasnip = require('luasnip')
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {
    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
    keyword_length = 1,
  },
  preselect = cmp.PreselectMode.Item,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
)
equire("cmp_git").setup() ]]--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

local function copy(args) return args[1][1] or "" end

luasnip.add_snippets("yaml", {
  s("k8s-deployment", {
    t({"apiVersion: apps/v1", "kind: Deployment", "metadata:", "  name: "}), i(1, "my-app"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "  labels:", "    app: "}), f(copy, {1}),
    t({"", "spec:", "  replicas: "}), i(3, "1"),
    t({"", "  selector:", "    matchLabels:", "      app: "}), f(copy, {1}),
    t({"", "  template:", "    metadata:", "      labels:", "        app: "}), f(copy, {1}),
    t({"", "    spec:", "      containers:", "        - name: "}), f(copy, {1}),
    t({"", "          image: "}), i(4, "nginx:latest"),
    t({"", "          ports:", "            - containerPort: "}), i(5, "80"),
    t({"", "          resources:", "            requests:", "              cpu: "}), i(6, "100m"),
    t({"", "              memory: "}), i(7, "128Mi"),
    t({"", "            limits:", "              cpu: "}), i(8, "500m"),
    t({"", "              memory: "}), i(9, "512Mi"), t({"", ""}),
  }),
  s("k8s-service", {
    t({"apiVersion: v1", "kind: Service", "metadata:", "  name: "}), i(1, "my-service"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  type: "}), i(3, "ClusterIP"),
    t({"", "  selector:", "    app: "}), i(4, "my-app"),
    t({"", "  ports:", "    - protocol: TCP", "      port: "}), i(5, "80"),
    t({"", "      targetPort: "}), i(6, "8080"), t({"", ""}),
  }),
  s("k8s-configmap", {
    t({"apiVersion: v1", "kind: ConfigMap", "metadata:", "  name: "}), i(1, "my-config"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "data:", "  "}), i(3, "key"), t(": "), i(4, "value"), t({"", ""}),
  }),
  s("k8s-secret", {
    t({"apiVersion: v1", "kind: Secret", "metadata:", "  name: "}), i(1, "my-secret"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "type: Opaque", "data:", "  "}), i(3, "key"), t(": "), i(4, "base64value"), t({"", ""}),
  }),
  s("k8s-ingress", {
    t({"apiVersion: networking.k8s.io/v1", "kind: Ingress", "metadata:", "  name: "}), i(1, "my-ingress"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  ingressClassName: "}), i(3, "nginx"),
    t({"", "  rules:", "    - host: "}), i(4, "example.com"),
    t({"", "      http:", "        paths:", "          - path: "}), i(5, "/"),
    t({"", "            pathType: Prefix", "            backend:", "              service:", "                name: "}), i(6, "my-service"),
    t({"", "                port:", "                  number: "}), i(7, "80"), t({"", ""}),
  }),
  s("k8s-pod", {
    t({"apiVersion: v1", "kind: Pod", "metadata:", "  name: "}), i(1, "my-pod"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  containers:", "    - name: "}), i(3, "app"),
    t({"", "      image: "}), i(4, "nginx:latest"),
    t({"", "      ports:", "        - containerPort: "}), i(5, "80"), t({"", ""}),
  }),
  s("k8s-namespace", {
    t({"apiVersion: v1", "kind: Namespace", "metadata:", "  name: "}), i(1, "my-namespace"), t({"", ""}),
  }),
  s("k8s-pvc", {
    t({"apiVersion: v1", "kind: PersistentVolumeClaim", "metadata:", "  name: "}), i(1, "my-pvc"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  accessModes:", "    - "}), i(3, "ReadWriteOnce"),
    t({"", "  resources:", "    requests:", "      storage: "}), i(4, "1Gi"),
    t({"", "  storageClassName: "}), i(5, "standard"), t({"", ""}),
  }),
  s("k8s-hpa", {
    t({"apiVersion: autoscaling/v2", "kind: HorizontalPodAutoscaler", "metadata:", "  name: "}), i(1, "my-hpa"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  scaleTargetRef:", "    apiVersion: apps/v1", "    kind: Deployment", "    name: "}), i(3, "my-app"),
    t({"", "  minReplicas: "}), i(4, "1"),
    t({"", "  maxReplicas: "}), i(5, "10"),
    t({"", "  metrics:", "    - type: Resource", "      resource:", "        name: cpu", "        target:", "          type: Utilization", "          averageUtilization: "}), i(6, "80"), t({"", ""}),
  }),
  s("k8s-job", {
    t({"apiVersion: batch/v1", "kind: Job", "metadata:", "  name: "}), i(1, "my-job"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  template:", "    spec:", "      restartPolicy: OnFailure", "      containers:", "        - name: "}), i(3, "job"),
    t({"", "          image: "}), i(4, "busybox"),
    t({"", "          command: "}), i(5, '["sh", "-c", "echo hello"]'), t({"", ""}),
  }),
  s("k8s-cronjob", {
    t({"apiVersion: batch/v1", "kind: CronJob", "metadata:", "  name: "}), i(1, "my-cronjob"),
    t({"", "  namespace: "}), i(2, "default"),
    t({"", "spec:", "  schedule: "}), i(3, '"*/5 * * * *"'),
    t({"", "  jobTemplate:", "    spec:", "      template:", "        spec:", "          restartPolicy: OnFailure", "          containers:", "            - name: "}), i(4, "job"),
    t({"", "              image: "}), i(5, "busybox"),
    t({"", "              command: "}), i(6, '["sh", "-c", "date"]'), t({"", ""}),
  }),
  s("k8s-sa", {
    t({"apiVersion: v1", "kind: ServiceAccount", "metadata:", "  name: "}), i(1, "my-sa"),
    t({"", "  namespace: "}), i(2, "default"), t({"", ""}),
  }),
})
