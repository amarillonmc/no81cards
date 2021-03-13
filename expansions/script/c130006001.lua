--战火的开端
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006001)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,{1,m,2},"sp,rm",nil,nil,nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att = Duel.AnnounceAttribute(tp,1,0xff-ATTRIBUTE_DIVINE)
	e:SetLabel(att)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function cm.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsType(TYPE_MONSTER)
end
function cm.op(e,tp)
	local att = e:GetLabel()
	local g = Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #g <=0 then return end
	Duel.ConfirmCards(tp,g)
	local ag = g:Filter(Card.IsAttribute,nil,att)
	if #ag >0 then
		local sg = ag:Filter(cm.spfilter,nil,e,tp)
		if #sg > 0 then
			rshint.Select(tp,"sp")
			local sc = sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP)
		end
	else
		local rg = g:Filter(cm.rmfilter,nil,tp)
		if #rg <= 0 then return end
		local att = 0
		for tc in aux.Next(rg) do
			att = att|tc:GetAttribute()
		end
		local rmatt = Duel.AnnounceAttribute(tp,1,att)
		local rg2 = rg:Filter(Card.IsAttribute,nil,rmatt)
		Duel.Remove(rg2,POS_FACEDOWN,REASON_EFFECT)
	end
end