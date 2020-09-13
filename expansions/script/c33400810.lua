--八舞夕弦 浴衣
local m=33400810
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa341),2,true)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.stcon)
	e2:SetOperation(cm.stop)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0xa341) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.spfil(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,cm.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
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
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local seq1=aux.MZoneSequence(c:GetSequence())
	local seq2=seq
	if re:IsActiveType(TYPE_MONSTER) then seq=aux.MZoneSequence(seq) end
	if ((seq1==4-seq and rp==1-tp) or (seq1==seq and rp==tp)) or (rp==tp and math.abs(c:GetSequence()-seq)<=1 and loc==LOCATION_MZONE and seq2<5) then 
		local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Filter(cm.ckfilter1,nil,tp)			 
		if cg:GetCount()>0 and  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=cg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	else
		if Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)	   
		and Duel.SelectYesNo(tp,aux.Stringid(m,2))then 
		   if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then 
		   local sg=Duel.GetOperatedGroup()
		   local sc=sg:GetFirst()
		   Duel.Draw(tp,1,REASON_EFFECT)
		   if  Duel.IsPlayerCanDraw(tp,1) and sc:IsSetCard(0xa341) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
		   Duel.Draw(tp,1,REASON_EFFECT)
		   end  
		   end
		end
	end
end