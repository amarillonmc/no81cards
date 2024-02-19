local m=15000045
local cm=_G["c"..m]
cm.name="色带·芭斯特"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,c15000045.ffilter,2,false) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE+LOCATION_PZONE,0,Duel.Release,REASON_COST)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(aux.fuslimit)  
	c:RegisterEffect(e1)
	--synchro custom
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCondition(cm.syncon)
	--e1:SetTarget(cm.syntg)
	--e1:SetValue(1)
	--e1:SetOperation(cm.synop)
	--c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15000045,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,15000045)  
	e2:SetCost(c15000045.spcost) 
	e2:SetCondition(c15000045.sdcon)
	e2:SetTarget(c15000045.sptg)
	e2:SetOperation(c15000045.spop)  
	c:RegisterEffect(e2)
end
function c15000045.ffilter(c,fc,sub,mg,sg)  
	return c:IsFusionType(TYPE_PENDULUM) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c15000045.f2filter,1,c,c:GetLeftScale()))
end
function c15000045.f2filter(c,les)
	return c:IsFusionType(TYPE_PENDULUM) and (c:GetLeftScale()==les or c:GetLeftScale()==les+1 or c:GetLeftScale()==les-1)
end
function c15000045.cfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c15000045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(c15000045.cfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,c15000045.cfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)  
	end
end
function c15000045.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000045.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000045.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1)
end
function c15000045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end
function c15000045.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(15000045,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
			local sg=g:Select(tp,1,1,nil)  
			Duel.SynchroSummon(tp,sg:GetFirst(),c)
		end
	end
end