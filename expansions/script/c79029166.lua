--罗德岛·术士干员-炎熔
function c79029166.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029166.dscost)
	e1:SetOperation(c79029166.dop)
	c:RegisterEffect(e1)
end
function c79029166.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5087128,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetTarget(c79029166.destg)
	e1:SetOperation(c79029166.desop)
	c:RegisterEffect(e1)
end
function c79029166.fil(c,e)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c79029166.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029166.fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029166.fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029166.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and  math.abs(seq-s)==1 and c:IsControler(tp)
end
function c79029166.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c79029166.desop(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetHandler():GetBattleTarget()
	local seq=a:GetSequence()
		 local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c79029166.desfilter2,tp,0,LOCATION_MZONE,nil,seq,a:GetControler()) end
		if dg:GetCount()>0 then
		   if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local x=dg:GetCount()*800
		Duel.Damage(1-tp,x,REASON_EFFECT)
end
	end
end
