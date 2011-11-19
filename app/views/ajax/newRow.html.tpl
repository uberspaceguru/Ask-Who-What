                  <tr class="<?= $_GET['class'] ?>">
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][floor]"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][apt_num]"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][price]" style="width: 30px;"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][bed]"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][bath]"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][sqft]" style="width: 30px;"></td>
                    <td><input type="text" name="wizard2[<?= $_GET['rowNum'] ?>][size]"></td>
                    <td>
                      <input type="file" name="wizard2[<?= $_GET['rowNum'] ?>][file]" class="hidden">
                      <button type="button" class="for_floor">Browse</button>
                    </td>
                    <td>
                      <div class="specs">
                        <input type="text" id="newItem<?= $_GET['rowNum'] ?>" style="margin: 0 10px 0 0;">
                        <select id="specs" name="wizard2[<?= $_GET['rowNum'] ?>][specs][]" multiple="multiple" class="addable<?= $_GET['rowNum'] ?>">
  <? foreach(ListingSpec::all() as $spec) { ?>
                          <option value="<?= $spec->id ?>"><?= $spec->spec ?></option>
  <? } ?>
                        </select><br>
                        <input type="button" id="add<?= $_GET['rowNum'] ?>" value="Add" style="margin: 5px 0 0; float: none;" class="create submit">
                      </div>
                      <button type="button" class="add_specs">Specs</button>
                    </td>
                    <td class="status_1">
                      <select name="wizard2[<?= $_GET['rowNum'] ?>][status_1_id]" class="single">
<? foreach(Status1::all() as $status) { ?>
                        <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                      </select>
                    </td>
                    <td>
                      <select name="wizard2[<?= $_GET['rowNum'] ?>][status_2_id]" class="single">
<? foreach(Status2::all() as $status) { ?>
                        <option value="<?= $status->id ?>"><?= $status->status ?></option>
<? } ?>
                      </select>
                    </td>
                    <td>
                      <div class="avail hidden">
                        <input type="checkbox" name="wizard2[<?= $_GET['rowNum'] ?>][avail]" checked="checked" id="avail<?= $_GET['rowNum'] ?>">
                        <input type="text" class="left" style="margin: 5px 0 0;" id="date<?= $_GET['rowNum'] ?>" name="wizard2[<?= $_GET['rowNum'] ?>][dateAvail]">
                      </div>
                      <button type="button" class="avail_check">Availability</button>
                      <button type="button" class="calendar">Calendar</button>
                      <div class="calcont"></div>
                      <script type="text/javascript">
                        $('#date<?= $_GET['rowNum'] ?>').datepicker();
                        $("select.single").multiselect({
                          header: false,
                          multiple: false,
                          selectedList: 1
                        }).multiselectfilter();
                        $("select.multiple").multiselect();
                        $(".specs").addClass(function() {
                          return $(this).parent().parent().attr('class');
                        });
                        $(".addable<?= $_GET['rowNum'] ?>").multiselect().multiselectfilter()

                      	var disabled = $('#disabled<?= $_GET['rowNum'] ?>'),
                    		selected = $('#selected<?= $_GET['rowNum'] ?>');
		
                    		$("#newItem<?= $_GET['rowNum'] ?>").keypress(function(e) {
                          if(e.keyCode == 13) {
                            if($('#newItem<?= $_GET['rowNum'] ?>').val().trim() != '') {
                          		var v = $('#newItem<?= $_GET['rowNum'] ?>').val(), opt = $('<option />', {
                          			value: v,
                          			text: v
                          		});
		
                          		opt.attr('selected','selected');
		
                          		opt.appendTo( $(".addable<?= $_GET['rowNum'] ?>").multiselect().multiselectfilter() );
                          		$('#newItem<?= $_GET['rowNum'] ?>').val("");
		
                          		$(".addable<?= $_GET['rowNum'] ?>").multiselect().multiselectfilter().multiselect('refresh');
                          	}
                            return false;
                          }
                        });
	  
                      	$("#add<?= $_GET['rowNum'] ?>").click(function(){
                    		  if($('#newItem<?= $_GET['rowNum'] ?>').val().trim() != '') {
                        		var v = $('#newItem<?= $_GET['rowNum'] ?>').val(), opt = $('<option />', {
                        			value: v,
                        			text: v
                        		});
		
                        		opt.attr('selected','selected');
		
                        		opt.appendTo( $(".addable<?= $_GET['rowNum'] ?>").multiselect().multiselectfilter() );
                        		$('#newItem<?= $_GET['rowNum'] ?>').val("");
		
                        		$(".addable<?= $_GET['rowNum'] ?>").multiselect().multiselectfilter().multiselect('refresh');
                        	}
                      	});
                      </script>
                    </td>
                  </tr>