<div id="wrapper">

    <div id="page-wrapper">

        <h1>Test upload image</h1>
        <p>Test upload image.</p>

		<form id="form" enctype="multipart/form-data" method="post" action="uploadfunction" />
			<fieldset>
				<!-- Form Name -->
                <legend></legend>
				
				<input type="hidden" name="MAX_FILE_SIZE" value="1048576" />
				<div class="form-group">
					<label class="col-md-4 control-label" for="title">Photo upload</label>
					<div class="col-md-8">
						<input type="file" class="form-control" size="32" name="my_field" value="" />
					</div>
					<p class="help-block">Max file size 1MB.</p>
					<input type="hidden" name="action" value="simple" />
					
					<!-- Button -->
					<div class="form-group">
						<label class="col-md-4 control-label" for="submit"></label>
						<div class="col-md-8">
							<input id="button" type="submit" name="submit" class="btn btn-primary">Upload</button>
							<div id="alert_placeholder"></div>
						</div>
					</div>
				</div>
			</fieldset>
		</form>
		<!-- preview action or error msgs -->
		<div id="preview" style="display:none"></div>

	</div><!-- /#page-wrapper -->
</div><!-- /#wrapper -->