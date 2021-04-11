local m=15000044
local cm=_G["c"..m]
cm.name="色带·星之彩"
function cm.initial_effect(c)
	--xyz summon  
	c:EnableReviveLimit()  
	aux.AddXyzProcedureLevelFree(c,c15000044.mfilter,c15000044.xyzcheck,2,4)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_GRAVE)  
	e1:SetCountLimit(1,15010044)  
	e1:SetCondition(c15000044.sdcon)
	e1:SetOperation(c15000044.xzcop)
	c:RegisterEffect(e1)
	-- Battle Damage
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)
	--destroy  
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(15000044,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,15020044)  
	e4:SetCost(c15000044.descost)  
	e4:SetTarget(c15000044.destg)  
	e4:SetOperation(c15000044.desop)  
	c:RegisterEffect(e4)
end
function c15000044.mfilter(c,xyzc)  
	return c:IsXyzType(TYPE_PENDULUM) 
end  
function c15000044.xyzcheck(g)  
	return g:GetClassCount(Card.GetLeftScale)==1  
end
function c15000044.cfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000044.c2filter(c)  
	return c:IsDestructable()
end 
function c15000044.c3filter(c)  
	return c:IsSetCard(0xf33) and c:IsType(TYPE_MONSTER) and not c:IsCode(15000044)
end
function c15000044.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000044.cfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 
end
function c15000044.xzcop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if ag:GetCount()~=0 then
		if Duel.Destroy(ag,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if ag:GetFirst():IsCanOverlay() then
				Duel.Overlay(e:GetHandler(),ag)
			end
		end
	end
	e:GetHandler():CompleteProcedure()
end
function c15000044.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	local rt=e:GetHandler():GetOverlayCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,rt,REASON_COST) end  
	local ct=c:RemoveOverlayCard(tp,rt,rt,REASON_COST)  
	e:SetLabel(ct)  
end  
function c15000044.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local ct=e:GetLabel()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local tg=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)  
end  
function c15000044.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if g:GetCount()>0 then  
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		local ag=Duel.GetMatchingGroup(c15000064.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
		if ag:GetCount()==2 then
			local cc=ag:GetFirst()
			local lsc=cc:GetLeftScale()
			local dc=ag:GetNext()
			local l2sc=dc:GetLeftScale()
			if (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.SelectYesNo(tp,aux.Stringid(15000044,1)) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 then  
				local bg=Duel.SelectMatchingCard(tp,c15000044.c3filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
				local tc=bg:GetFirst()
				if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end  
end