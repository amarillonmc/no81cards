--八舞耶俱矢 贯穿之风
local m=33400807
local cm=_G["c"..m]
function cm.initial_effect(c) 
	  --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.stcon)
	e3:SetTarget(cm.sttg)
	e3:SetOperation(cm.stop)
	c:RegisterEffect(e3)
end
function cm.ckfilter1(c,tp,seq) 
	local seq1=aux.MZoneSequence(c:GetSequence())
	return  c:IsFaceup() and  math.abs(seq-seq1)<=1
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
   c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	 local seq=aux.MZoneSequence(c:GetSequence())
	   local cg=Duel.GetMatchingGroup(cm.ckfilter1,tp,LOCATION_MZONE,0,nil,tp,seq) 
	   if cg:GetCount()>0  then 
			local tc=cg:GetFirst()
			while tc do  
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(800)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(800)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				tc=cg:GetNext()
			end 
	   end
end

function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler()
end
function cm.thfilter1(c)
	return  c:IsSetCard(0xa341) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.ckfilter(c,tp)
	return  c:IsType(TYPE_MONSTER) and c:IsAttackPos() and c:IsControler(tp)
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end 
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,m)local tc=tg:GetFirst()
	while tc do
	  tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3)) 
	tc=tg:GetNext()  
	end   
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=seq
	if re:IsActiveType(TYPE_MONSTER) then seq=aux.MZoneSequence(seq) end
	if ((seq1==4-seq and rp==1-tp) or (seq1==seq and rp==tp)) or (rp==tp and math.abs(c:GetSequence()-seq)<=1 and loc==LOCATION_MZONE and seq2<5) then 
		   local cg=c:GetColumnGroup(1,1):Filter(cm.ckfilter,nil,1-tp)  
		   if cg:GetCount()>0  then 
				local tc=cg:GetFirst()
				while tc do  
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
					tc=cg:GetNext()
				end 
		   end  
	else
		if  Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end



