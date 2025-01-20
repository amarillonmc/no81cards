--断你电脑网plus
local s,id,o=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		Duel.DisableActionCheck(true)
		local tp=0
		if Duel.GetFieldGroupCount(0,0,LOCATION_DECK)>0 or Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 then tp=1 end
		Debug.Message(tp)
		local ec=Debug.AddCard(id,0,0,LOCATION_EXTRA,0,POS_FACEDOWN)
		pcall(Duel.Overlay,ec,c)
		local _,g=pcall(Card.GetOverlayGroup,ec)
		pcall(Group.Select,g,1-tp,1,1,nil)
		Duel.DisableActionCheck(false)
	end
end
