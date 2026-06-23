--吞式者的爆发
local m=14000321
local cm=_G["c"..m]
cm.named_with_Aotual=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000324)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RELEASE+CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.costchk)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.dacon)
	c:RegisterEffect(e3)
end
function cm.AOTU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Aotual
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and cm.AOTU(c) and c:IsReleasable() and c:IsCode(14000324)
end
function cm.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(14000324) and c:IsType(TYPE_RITUAL) and cm.AOTU(c) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function cm.rfilter(c,e,tp)
	return cm.filter(c) or cm.filter1(c,e,tp)
end
function cm.spfilter(c,e,tp,lv)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsLevel(lv)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		local b2=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return b1 or b2 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		local rc=g:GetFirst()
		local atk1,atk2=rc:GetAttack(),0
		local lv=rc:GetLevel()
		if Duel.Release(rc,REASON_EFFECT)~=0 then
			if rc:IsCode(14000324) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.HintSelection(g)
					atk2=tc:GetAttack()
					Duel.Destroy(tc,REASON_EFFECT)
				end
				if atk1>0 and atk2>0 then
					Duel.Damage(1-tp,math.max(atk1,atk2),REASON_EFFECT)
				end
			elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
				local tc=g:GetFirst()
				if tc then
					tc:SetMaterial(mat)
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
		end
	end
end
function cm.handfilter(c)
	return c:IsCode(14000324) and not c:IsPublic()
end
function cm.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.handfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end