--刻刻帝 「十之弹」
function c33400110.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400110+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(2)
	e1:SetCost(c33400110.cost)
	e1:SetTarget(c33400110.target)
	e1:SetOperation(c33400110.activate)
	c:RegisterEffect(e1)
end
function c33400110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400110.filter(c)
	return c:IsFaceup() 
end
function c33400110.ss(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
function c33400110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c33400110.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	 local lvt={}
	lvt[1]=1
	if  Duel.GetMatchingGroupCount(c33400110.ss,tp,LOCATION_GRAVE,0,nil)>=3 then lvt[2]=2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400110,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400110.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,sc1,sc1,nil)
end
function c33400110.activate(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
		local sc=g:GetFirst()
			while sc do  
				 local c=e:GetHandler()
				 local e1=Effect.CreateEffect(c)
				 e1:SetType(EFFECT_TYPE_FIELD)
				 e1:SetCode(EFFECT_DISABLE)
				 e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				 e1:SetTarget(c33400110.distg)
				 e1:SetLabelObject(sc)
				 e1:SetReset(RESET_PHASE+PHASE_END)
				 Duel.RegisterEffect(e1,tp)
				 local e2=Effect.CreateEffect(c)
				 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				 e2:SetCode(EVENT_CHAIN_SOLVING)
				 e2:SetCondition(c33400110.discon)
				 e2:SetOperation(c33400110.disop)
				 e2:SetLabelObject(sc)
				 e2:SetReset(RESET_PHASE+PHASE_END)
				 Duel.RegisterEffect(e2,tp)
				 sc=g:GetNext()
			end
		end
   Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function c33400110.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400110.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400110.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end