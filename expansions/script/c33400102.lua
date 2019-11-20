--刻刻帝---「二之弹」
function c33400102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33400102+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400102.target)
	e1:SetOperation(c33400102.activate)
	c:RegisterEffect(e1)
end
function c33400102.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3341)
end
function c33400102.filter(c)
	return c:IsFaceup() 
end
function c33400102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.IsExistingTarget(c33400102.cfilter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsCanRemoveCounter(tp,1,0,0x34f,1,REASON_COST)
	end
	local sc=Duel.GetMatchingGroupCount(c33400102.cfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c33400102.filter(chkc) end
	if chk==0 then return sc>0 and Duel.IsExistingTarget(c33400102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,-1,nil) end
	local cn=Duel.GetCounter(tp,1,0,0x34f)
	local lvt={}
	for i=1,7 do
	 if i<=cn and i<=sc then lvt[i]=i   end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400102,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
   Duel.RemoveCounter(tp,1,0,0x34f,sc1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33400102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,sc1,sc1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_LVCHANGE,g,g:GetCount(),0,0)
end
function c33400102.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(sc:GetAttack()/2)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(sc:GetDefense()/2)
		sc:RegisterEffect(e2)   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e4)   
		sc=g:GetNext()
		end
	end
	Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end