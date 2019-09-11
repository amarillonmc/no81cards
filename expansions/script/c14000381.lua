--
local m=14000381
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.spfilter(c)
	return c:IsCode(14000380) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) and (c:IsLocation(LOCATION_GRAVE) or Duel.IsPlayerAffectedByEffect(tp,14000386))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
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
					local ats=tc:GetAttackableTarget()
					if not tc:IsAttackable() or tc:IsImmuneToEffect(e) or ats:GetCount()==0 then return end 
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
					local g=ats:Select(tp,1,1,nil)
					Duel.HintSelection(g)
					Duel.CalculateDamage(tc,g:GetFirst())
				end
			end
		end
	end
end