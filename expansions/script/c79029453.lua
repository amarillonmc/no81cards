--萨尔贡·术士干员-异客
function c79029453.initial_effect(c)
	c:SetSPSummonOnce(79029453)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c79029453.ovfilter,aux.Stringid(79029453,0))
	c:EnableReviveLimit() 
	--th 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029453.thcon)
	e1:SetTarget(c79029453.thtg)
	e1:SetOperation(c79029453.thop)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029453,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029453.seqcost)
	e2:SetTarget(c79029453.seqtg)
	e2:SetOperation(c79029453.seqop)
	c:RegisterEffect(e2)   
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(c79029453.adcon)
	e2:SetValue(c79029453.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(c79029453.defval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c79029453.damcon)
	e4:SetOperation(c79029453.damop)
	c:RegisterEffect(e4)
	--Draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,79029453)
	e5:SetTarget(c79029453.drtg)
	e5:SetOperation(c79029453.drop)
	c:RegisterEffect(e5)
	--fj
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,19029453)
	e6:SetCondition(c79029453.fjcon)
	e6:SetTarget(c79029453.fjtg)
	e6:SetOperation(c79029453.fjop)
	c:RegisterEffect(e6)	
end
function c79029453.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c79029453.adcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c79029453.atkval(e,c)
	return c:GetAttack()*2
end
function c79029453.defval(e,c)
	return c:GetDefense()*2
end
function c79029453.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029453.thfilter(c,e,tp)
	return c:IsSetCard(0xb90d) and c:IsAbleToHand()
end
function c79029453.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029453.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029453.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("谋略和计策我熟稔在心，当然，如果您另有想法的话。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029453,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029453.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79029453.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029453.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c79029453.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end
function c79029453.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c79029453.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,16 do
		if not Duel.IsExistingMatchingCard(c79029453.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(c79029453.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79029453.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(c79029453.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c79029453.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Debug.Message("出于您的意愿。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029453,1))
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	local tc=g:GetFirst()
	while tc do
	peq=tc:GetPreviousSequence()
	if tc:IsPreviousLocation(LOCATION_MZONE) then 
	val=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,peq)
	elseif tc:IsPreviousLocation(LOCATION_SZONE) then 
	val=aux.SequenceToGlobal(1-tp,LOCATION_SZONE,peq)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)  
	tc=g:GetNext()
	end
end
function c79029453.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c79029453.damop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("灰飞烟灭吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029453,2))
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c79029453.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=0 
	if Duel.CheckLocation(tp,LOCATION_MZONE,0) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,1) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,2) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,3) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,4) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,5) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_MZONE,6) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,0) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,1) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,2) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,3) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,4) then 
	op=op+1
	end
	if Duel.CheckLocation(tp,LOCATION_SZONE,5) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,0) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,1) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,2) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,3) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,4) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,0) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,1) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,2) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,3) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,4) then 
	op=op+1
	end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,5) then 
	op=op+1
	end
	local x=24-op-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return x>0 and Duel.IsPlayerCanDraw(tp,x) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
end
function c79029453.drop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("现在，我们的布局天衣无缝。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029453,3))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029453.fjcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and rp==1-tp and ev>=1000
		and (re or Duel.GetAttacker())
end
function c79029453.fjtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c79029453.fjop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=math.floor(ev/1000)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("不算甜美的失败，博士，但请放心，那些从您手中夺走胜利的人，一定会饱尝苦楚。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029453,4))
	local dg=g:Select(tp,1,x,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	local tc=dg:GetFirst()
	while tc do
	peq=tc:GetPreviousSequence()
	if tc:IsPreviousLocation(LOCATION_MZONE) then 
	val=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,peq)
	elseif tc:IsPreviousLocation(LOCATION_SZONE) then 
	val=aux.SequenceToGlobal(1-tp,LOCATION_SZONE,peq)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)  
	tc=dg:GetNext()
	end
end





