--龙血师团-†深典†-
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009479)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,nil,nil,{1,m,1},"sp","tg",nil,nil,rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.rcon)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3f1b) and rscf.spfilter2()(c,e,tp)
end
function cm.act(e,tp)
	local c,tc = rscf.GetFaceUpSelf(e),rscf.GetTargetCard()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	c:SetCardTarget(tc)
	e:GetLabelObject():SetLabelObject(tc)
	c:CreateRelation(tc,RESET_EVENT+0x5020000)
	tc:CreateRelation(c,RESET_EVENT+0x5fe0000)  
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x3f1b)
		and e:GetHandler():IsAbleToRemoveAsCost()
		and ep==e:GetOwnerPlayer() and ev==1
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
