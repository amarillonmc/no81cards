--Neo-Aspect宇田川亚子
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010100
local cm=_G["c"..m]
function cm.initial_effect(c)   
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	local e1=rsef.FV_LIMIT(c,"dis",nil,cm.tg,{LOCATION_ONFIELD,LOCATION_ONFIELD })
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
	local e3=rsef.QO(c,nil,{m,0},{1,m},nil,"tg",LOCATION_MZONE,nil,rscost.rmxyz(2),rstg.target(cm.xyzfilter,nil,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.xyzop)
end
function cm.xyzfilter(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler()) 
end
function cm.xyzop(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard()
	if c and tc and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function cm.tg(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return c:GetOriginalCode()~=m and #g>0 and g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,c:GetOriginalCode()),1,nil) 
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	local rc=re:GetHandler()
	return rc:GetOriginalCode()~=m and #g>0 and g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,rc:GetOriginalCode()),1,nil) 
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
