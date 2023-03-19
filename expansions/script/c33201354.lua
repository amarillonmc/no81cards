--六合精工 上阳台帖
local m=33201354
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	--deckes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.VHisc_CNTreasure=true

--e1
function cm.thfilter(c,cg)
	return VHisc_CNTdb.nck(c) and not cg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.grfilter(c)
	return VHisc_CNTdb.nck(c) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(cm.grfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,cg) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.grfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,cg)
	if sg:GetCount()>0 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=sg:SelectSubGroup(tp,aux.dncheck,false,1,1)
		Duel.HintSelection(sg1)
		local code=sg1:GetFirst():GetCode()
		Duel.Hint(HINT_CARD,1-tp,code)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		--deckes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1)
		e1:SetLabel(code)
		e1:SetOperation(cm.edop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		c:RegisterEffect(e1)
	end
end
function cm.edop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,33201354)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) and VHisc_CNTdb.spck(e,tp) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(cm.espfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(33201354,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.espfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,SUMMON_VALUE_GLADIATOR,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function cm.espfilter(c,e,tp)
	local cg=Duel.GetMatchingGroup(cm.grfilter,tp,LOCATION_GRAVE,0,nil)
	return VHisc_CNTdb.nck(c) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_GLADIATOR,tp,true,false) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or (c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) and not cg:IsExists(Card.IsCode,1,nil,c:GetCode())
end