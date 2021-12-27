module.exports = {
	apps: [
	{
		name: 'react',
		script: 'npm',
		args: 'run start',
		watch: true,
		"watch_options": {
			usePolling: true
		},
		env: {
			PORT: 3002
		},
		env_production: {
			NODE_ENV: 'production'
		}
	}
	]
};
