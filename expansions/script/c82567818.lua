--方舟骑士·王棋皇后 阿米娅
function c82567818.initial_effect(c)
	c:SetSPSummonOnce(82567818)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c82567818.linkfilter),2,4)
	c:EnableReviveLimit()
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567818,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82567818)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c82567818.tdcost)
	e4:SetTarget(c82567818.tdtg)
	e4:SetOperation(c82567818.tdop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567818,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,82567818)
	e5:SetCost(c82567818.dmcost)
	e5:SetTarget(c82567818.dmtg)
	e5:SetOperation(c82567818.dmop)
	c:RegisterEffect(e5)
	--Amiya change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82567818,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c82567818.spcost)
	e7:SetTarget(c82567818.sptg)
	e7:SetOperation(c82567818.spop)
	c:RegisterEffect(e7)
end
function c82567818.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetMutualLinkedGroupCount()>0 and 
		   Duel.CheckReleaseGroup(1-tp,nil,1,nil) end
	 local sg=Duel.GetMatchingGroup(c82567818.costfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=sg:Select(tp,1,1,nil)
	Duel.Release(tc,REASON_COST)
end
function c82567818.costfilter(c)
	return c:IsReleasable()
end 
function c82567818.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c82567818.dmop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Damage(tp,1000,REASON_EFFECT)
	
end
function c82567818.linkfilter(c)
	return c:IsType(TYPE_LINK)
end
function c82567818.rdval(e,c)
	local c=e:GetHandler()
	return c:GetLinkedGroupCount()*500
end
function c82567818.atkupcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c82567818.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567818.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_MZONE)
end
function c82567818.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	g:AddCard(e:GetHandler())
	if e:GetHandler():IsAbleToGrave() and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then 
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	end
end
function c82567818.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c82567818.spfilter(c,e,tp,mc)
	return  c:IsSetCard(0xa826)  and not c:IsType(TYPE_XYZ) and not c:IsCode(82567818) and 
			   c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
	  and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82567818.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return 
		 Duel.IsExistingMatchingCard(c82567818.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end
function c82567818.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567818.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 then return end
	if 
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82567818.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
   end
end
function c82567818.splimit(e,c)
	return c:IsSetCard(0xa826)
end