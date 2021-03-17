--八舞夕弦 战斗前夕
local m=33400811
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa341),2,true)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.hspcon)
	e0:SetOperation(cm.hspop)
	c:RegisterEffect(e0)
	  --move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.seqtg)
	e1:SetOperation(cm.seqop)
	c:RegisterEffect(e1)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.stcon)
	e2:SetTarget(cm.sttg)
	e2:SetOperation(cm.stop)
	c:RegisterEffect(e2)
end
function cm.hspfilter(c,tp,sc)
	return c:IsSetCard(0xa341) and  Duel.GetFlagEffect(tp,c:GetCode())==0
	 and  Duel.GetFlagEffect(tp,c:GetCode()+10000)==0   and c:IsControler(tp)  and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter2,1,c,c:GetControler(),sc,tc)
end
function cm.hspfilter2(c,tp,sc,tc)
	local g=Group.CreateGroup()
	g:AddCard(tc)
	g:AddCard(c)
	return c:IsSetCard(0xa341) 
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) 
end
function cm.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter,1,nil,c:GetControler(),c)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,tp,c)
	local tc1=g1:GetFirst()
	local g2=Duel.SelectReleaseGroup(tp,cm.hspfilter2,1,1,tc1,tp,c,tc1)
	local tc2=g2:GetFirst()
	g2:Merge(g1)
	c:SetMaterial(g2)
	Duel.Release(g2,REASON_COST)
	Duel.RegisterFlagEffect(tp,tc1:GetCode()+10000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
	Duel.RegisterFlagEffect(tp,tc2:GetCode()+10000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
	local tg1=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,tc1:GetCode())
	local tc1=tg1:GetFirst()
	while tc1 do
	  tc1:RegisterFlagEffect(tc1:GetCode()+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4)) 
	tc1=tg1:GetNext()  
	end  
	local tg2=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,tc2:GetCode())
	local tc2=tg2:GetFirst()
	while tc2 do
	  tc2:RegisterFlagEffect(tc2:GetCode()+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4)) 
	tc2=tg2:GetNext()  
	end 
end

function cm.seqfilter(c)
	return c:IsFaceup() 
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
local c=e:GetHandler()
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.tgfilter)
	e1:SetValue(cm.imfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter(e,c)
	return c:IsSetCard(0xa341) and c:IsLocation(LOCATION_MZONE)
end
function cm.imfilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()and not  e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end

function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and re:GetHandler()~=e:GetHandler()
end
function cm.ckfilter1(c,tp)
	local seq=c:GetSequence()
	local g1=c:GetColumnGroup():Filter(cm.cckfilter,nil,tp)
	return   c:IsAbleToHand() and  (g1:GetCount()>0 or (c:IsSetCard(0xa341) and c:IsFaceup() and c:IsControler(tp) ))
end
function cm.cckfilter(c,tp)
	return  c:IsSetCard(0xa341) and c:IsFaceup() and c:IsControler(tp) 
end
function cm.ckfilter(c,tp)
	local seq=c:GetSequence()
	return  c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsAbleToHand() and seq<5
end
function cm.setfilter(c)
	return c:IsSetCard(0xa341) and  c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end 
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_PHASE+PHASE_END,0,0) 
local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,m)local tc=tg:GetFirst()
	while tc do
	  tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5)) 
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
	  if  Duel.GetCurrentPhase()==PHASE_DRAW then ph=PHASE_STANDBY end
	  if  Duel.GetCurrentPhase()==PHASE_STANDBY then ph=PHASE_MAIN1 end
	  if  Duel.GetCurrentPhase()==PHASE_MAIN1 then ph=PHASE_BATTLE end
	  if  Duel.GetCurrentPhase()==PHASE_BATTLE then ph=PHASE_MAIN2 end
	  if  Duel.GetCurrentPhase()==PHASE_MAIN2 then ph=PHASE_END end
		--disable
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetReset(RESET_PHASE+ph)
		Duel.RegisterEffect(e2,tp)
	else
		if  Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1))then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
			local tc=g:GetFirst()
			if  Duel.SSet(tp,tc)~=0 then
			   local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			   local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function cm.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0xa341) and seq1==4-seq2
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and loc&LOCATION_SZONE==LOCATION_SZONE and seq<=4
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
   and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,m)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end


