--破军歌姬 进行曲
local m=33400952
local cm=_G["c"..m]
function cm.initial_effect(c)
  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400952,4))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc341) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c)
	return c:IsFaceup() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return sc>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,sc,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and  g:GetCount()>0 then
	local c=e:GetHandler()
	local ops={}
	local opval={} 
		ops[1]=aux.Stringid(m,1)
		opval[0]=1
		ops[2]=aux.Stringid(m,2)
		opval[1]=2   
		ops[3]=aux.Stringid(m,3)
		opval[2]=3  
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	local tc=g:GetFirst()
	if sel==1 then
		 while tc do  
			local e1=Effect.CreateEffect(c)	
			e1:SetType(EFFECT_TYPE_SINGLE)	  
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		  end
	elseif sel==2 then
		 while tc do  
			  --attack twice
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(m,2))
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetValue(1)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		  end		 
	else
		while tc do  
	   --pierce
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,3))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
		end 
	end
	end   
end