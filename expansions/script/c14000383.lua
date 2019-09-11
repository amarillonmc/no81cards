--荒碑守 守碑
local m=14000383
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.sscon)
	e1:SetTarget(cm.sstg)
	e1:SetOperation(cm.ssop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.filter(c)
	return c:IsCode(14000380)
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) and (c:IsLocation(LOCATION_GRAVE) or Duel.IsPlayerAffectedByEffect(tp,14000386))
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function cm.sfilter(c,e,tp)
	return cm.Grava(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
					if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					c:RegisterEffect(e2)
				end
			end
		end
	end
end