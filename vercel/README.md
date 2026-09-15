# Vercel deployment

The Vercel build runs `npm run verify`, which validates and transpiles the ABAP
sources into `output/`. Verification is deliberately not repeated when a
function instance starts.

`vercel.json` stays in the repository root so both Git-triggered deployments
and `vercel\deploy.cmd` use the same function packaging configuration.

## First deployment

1. Install the CLI: `npm install --global vercel`
2. Authenticate: `vercel login`
3. Link or create the project: `vercel\deploy.cmd link`
4. Test locally: `vercel\deploy.cmd dev` (this runs `npm run verify` first)
5. Create a preview: `vercel\deploy.cmd preview`
6. Publish production: `vercel\deploy.cmd deploy`

Later production deployments only require `vercel\deploy.cmd`.

The generated `.vercel/` project link is local metadata and is ignored by Git.
