--方舟骑士-阿米娅·跨越悲伤
c29012778.named_with_Arknight=1
function c29012778.initial_effect(c)
	aux.AddCodeList(c,29065500,29079596)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,29065500,29079596,true,true)
	--change name
	--aux.EnableChangeCode(c,29065500)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29012778+EFFECT_COUNT_CODE_DUEL)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c29012778.atktg)
	e1:SetOperation(c29012778.atkop)
	c:RegisterEffect(e1)
end
function c29012778.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c29012778.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #tg>0 then
		local tc=tg:GetFirst()
		while tc do
			local atk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(atk/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(ct*700)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c29012778.ceop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c29012778.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c29012778.ceop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex3,tg3,tc3=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	local b1=ex1 and tg1~=nil and tc1+tg1:FilterCount(c29012778.cfilter,nil,tp)-tg1:GetCount()>0
	local b2=ex2 and tg2~=nil and tc2+tg2:FilterCount(c29012778.cfilter,nil,tp)-tg2:GetCount()>0
	local b3=ex3 and tg3~=nil and tc3+tg3:FilterCount(c29012778.cfilter,nil,tp)-tg3:GetCount()>0
	if ep~=tp and (b1 or b2 or b3) then
		Duel.Hint(HINT_CARD,0,29012778)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c29012778.reop)
	end
end
function c29012778.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end
