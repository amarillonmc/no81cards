--冥府的女主人·奈芙缇丝
local cm,m,o=GetID()
function cm.initial_effect(c)
	--n
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(m,0))
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e4:SetCode(EVENT_FREE_CHAIN)
	--e4:SetRange(LOCATION_DECK) 
	--e4:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	--e4:SetCondition(cm.con)
	--e4:SetOperation(cm.op)
	--c:RegisterEffect(e4)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
cm.SetCard_XdMcy=true 
if not cm.nzr_change_operation then
	cm.nzr_change_operation=true
	cm._set_code=Effect.SetCode
	Effect.SetCode=function (e,code,...)
		if (code==EFFECT_CANNOT_REMOVE or code==EFFECT_CANNOT_TO_DECK or code==EFFECT_CANNOT_TO_GRAVE or code==EFFECT_CANNOT_TO_GRAVE_AS_COST) and Duel.GetFlagEffect(tp,m)~=0 then
			cm._set_code(e,nil,...)
		else
			cm._set_code(e,code,...)
		end
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (rc.SetCard_XdMcy) and rc:IsControler(tp) and not rc:IsCode(m) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,tp,m)
		Duel.SetChainLimit(cm.chainlm)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(c,REASON_COST)
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local sg=g:Filter(cm.filter,nil,g)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function cm.filter(c,g)
	return c:GetSequence()==(#g-1)
end
function cm.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil):RandomSelect(tp,2)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.Destroy(g,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,1) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,2) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,3) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,4) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,5) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,6) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,7) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,8) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,9) and Duel.IsExistingMatchingCard(Card.IsLevel,tp,LOCATION_GRAVE,0,1,nil,10) then
			Duel.Win(tp,nil)
		end
	end
end









