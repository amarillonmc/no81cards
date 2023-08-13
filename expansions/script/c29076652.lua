--方舟骑士-晓歌
c29076652.named_with_Arknight=1
function c29076652.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	c:SetSPSummonOnce(29076652)
	aux.AddLinkProcedure(c,c29076652.matfilter,2,2)
	--pendulum set
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c29076652.pentg)
	e0:SetOperation(c29076652.penop)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22070401,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c29076652.cttg)
	e1:SetOperation(c29076652.ctop)
	c:RegisterEffect(e1)
	--set p
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22070401,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29076652.pentg1)
	e2:SetOperation(c29076652.penop1)
	c:RegisterEffect(e2)
c29076652.pendulum_level=5
end
function c29076652.penfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden() and not c:IsCode(29076652)
end
function c29076652.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c29076652.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c29076652.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c29076652.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c29076652.pentg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29076652.penop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29076652.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and c:IsCanAddCounter(0x10ae,ct) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x10ae)
end
function c29076652.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	if not c:IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,29076652,RESET_PHASE+PHASE_END,0,1)
	c:AddCounter(0x10ae,ct)
end
function c29076652.matfilter(c)
	return c:IsLinkSetCard(0x87af) or (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end