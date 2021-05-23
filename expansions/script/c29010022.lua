--荒败之城 盐风
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010022)
function cm.initial_effect(c)
	rscf.AddTokenList(c,29010023)
	--local e1 = rsef.A(c,nil,nil,nil,nil,nil,nil,nil,
		--rsop.target(cm.cfilter,"dum",LOCATION_MZONE),cm.act)  
	local e1 = rsef.A(c,nil,nil,nil,nil,nil,nil,nil,nil,cm.act2)  
	local e2 = aux.EnableChangeCode(c,22702055)
	local e3 = rsef.I(c,"tk",{1,m},"sp,tg,tk,se,th",nil,LOCATION_SZONE,
		nil,rscost.paylp(800),
		aux.AND(rstg.token(29010023,1,POS_FACEUP,1),
		rsop.target(cm.thfilter,"th,tg",LOCATION_DECK)),cm.tkop)
end
function cm.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsAttribute(ATTRIBUTE_WATER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tkop(e,tp)
	if rssf.SpecialSummonToken(e,tp,29010023,1,1,POS_FACEUP,1-tp) <= 0 then return end
	local og,tc = rsop.SelectCards("dum",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if not tc then return end
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.act(e,tp)
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(rsrst.std_ep,2)
		e1:SetValue(cm.xyzlv)
		tc:RegisterEffect(e1)
		if not tc:IsType(TYPE_EFFECT) and not tc:IsImmuneToEffect(e) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(rsrst.std_ep,2)
			tc:RegisterEffect(e2,true)
		end
	end
end
function cm.xyzlv(e,c,rc)
	return 0x80000+e:GetHandler():GetLevel()
end
function cm.act2(e,tp)
	local c = e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.xyzlv)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(cm.cfilter))
	e2:SetLabelObject(e1)
	e2:SetReset(rsrst.ep,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_EFFECT)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(cm.cfilter))
	e4:SetLabelObject(e3)
	e4:SetReset(rsrst.ep,2)
	Duel.RegisterEffect(e4,tp)
end