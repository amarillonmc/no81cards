--肃声之祈愿 理
local m=20101001
local cm=c20101001
function c20101001.initial_effect(c)
	c:SetSPSummonOnce(20101001)
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,25801745)
	aux.EnablePendulumAttribute(c)
	--draw
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m+2)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.lvtg)
	e3:SetOperation(cm.lvop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function cm.drfilter(c)
	return c:IsFaceup() and c:IsCode(10774240)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(cm.drfilter,tp,LOCATION_MZONE,0,nil)>0 and Duel.Destroy(c,REASON_EFFECT)~=0 then
				if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
				Duel.HintSelection(g)
				Duel.BreakEffect()
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function cm.lvfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGrave()
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lvfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.lvfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT)   end
end
function cm.fit(c)
	return c:IsReleasableByEffect() and c:IsCode(25801745)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		 and Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 and Duel.Release(g,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		end
	end
end