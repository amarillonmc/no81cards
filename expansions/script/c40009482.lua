--龙血师团-†巧计反礼†-
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009482)
function cm.initial_effect(c)
	local e1 = rsef.ACT(c,EVENT_CHAINING,"dis",nil,"dis","tg",rscon.discon(cm.efilter),nil,rstg.target2(cm.fun,cm.cfilter,nil,LOCATION_MZONE),cm.act)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.rcon)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
end
function cm.efilter(e,tp,re,rp,tg)
	return not tg:IsExists(Card.IsOnField,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x3f1b)
end
function cm.fun(g,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local rc,tc=re:GetHandler(),rscf.GetTargetCard(Card.IsFaceup)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and tc and tc:IsType(TYPE_XYZ) and not tc:IsImmuneToEffect(e) then
		rc:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(rc))
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