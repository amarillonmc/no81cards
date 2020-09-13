--八舞耶俱矢 战斗前夕
local m=33400813
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa341),2,true)
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
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.stcon)
	e2:SetOperation(cm.stop)
	c:RegisterEffect(e2)
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
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
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
function cm.spfilter1(c,e,tp)
	return  c:IsSetCard(0xa341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=seq
	if re:IsActiveType(TYPE_MONSTER) then seq=aux.MZoneSequence(seq) end
	if ((seq1==4-seq and rp==1-tp) or (seq1==seq and rp==tp)) or (rp==tp and math.abs(c:GetSequence()-seq)<=1 and loc==LOCATION_MZONE and seq2<5) then 
	  local ph=PHASE_END
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
		 if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1))then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
   and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,m)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end



