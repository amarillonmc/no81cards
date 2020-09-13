--绯红之夜的白月骑士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010579,"WMKnight")
if rswk then return end
rswk=cm 
rscf.DefineSet(rswk,"WMKnight")
rswk.UpCode=65010584
function rswk.EquipEffect(c,code,only_2)
	local e1=rsef.ACT(c,nil,nil,{1,code,1},nil,nil,nil,nil,cm.eftg(only_2),cm.efop)
	return e1
end
function cm.efthfilter(c)
	return c:IsAbleToHand() and rswk.IsSetM(c)
end
function cm.efspfilter(c,e,tp)
	return rswk.IsSetM(c) and (not c:IsLocation(LOCATION_GRAVE) or rscf.spfilter2()(c,e,tp)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eftg(only_2)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1=Duel.IsExistingMatchingCard(cm.efthfilter,tp,LOCATION_DECK,0,1,nil) and not only_2
		local b2=Duel.IsExistingMatchingCard(cm.efspfilter,tp,rsloc.mg,0,1,nil,e,tp)
		if chk==0 then return b1 or b2 end
		local op=only_2 and 2 or rsop.SelectOption(tp,b1,{m,2},b2,{m,1})
		if op==1 then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		else
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
			Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0)
		end 
		e:SetLabel(op)
	end
end
function cm.efop(e,tp)
	local c=rscf.GetSelf(e)
	local op=e:GetLabel()
	if op==1 then
		rsop.SelectToHand(tp,cm.efthfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	else
		if not c then return end
		rsop.SelectSolve(HINTMSG_SELF,tp,aux.NecroValleyFilter(cm.efspfilter),tp,rsloc.mg,0,1,1,nil,cm.effun,e,tp)
	end
end
function cm.effun(g,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc:IsLocation(LOCATION_GRAVE) and rssf.SpecialSummon(tc)<=0 then return false end	
	c:CancelToGrave(true)
	if not rsop.Equip(e,c,tc) then
		c:CancelToGrave(false)
	end
	return true
end
function rswk.GainEffect(c,ge)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(rswk.UpCode)
	e1:SetCondition(rscon.excard2(Card.IsType,LOCATION_ONFIELD,0,2,nil,TYPE_SPELL+TYPE_TRAP))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.eftg2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg2)
	e3:SetLabelObject(ge)
	c:RegisterEffect(e3)
	return e1,e2,e3
end
function cm.eftg2(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	return ec==c and rswk.IsSet(ec)
end
function rswk.gecon(e,tp)
	return e:GetHandler():IsCode(rswk.UpCode)
end
--------------------------------
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"dish,se,th",nil,nil,nil,nil,cm.act)
	local e2=rsef.I(c,{m,1},1,"eq,des","tg",LOCATION_FZONE,nil,nil,rstg.target({cm.eqfilter,"eq",LOCATION_MZONE },rsop.list(aux.TRUE,"des")),cm.eqop)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+100)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rswk.IsSetM(c)
end
function cm.act(e,tp)
	if not rscf.GetSelf(e) then return end
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then
		rsop.SelectOC({m,0})
		if rsop.SelectToGrave(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,{ REASON_EFFECT+REASON_DISCARD },REASON_EFFECT)>0 then
			rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
		end
	end
end
function cm.eqcfilter(c)
	return rswk.IsSetST(c) and not c:IsForbidden()
end
function cm.eqfilter(c,e,tp)
	return c:IsCode(rswk.UpCode) and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.eqcfilter,tp,rsloc.hg,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if rsop.SelectSolve(HINTMSG_EQUIP,tp,cm.eqcfilter,tp,rsloc.hg,0,1,1,nil,cm.eqfun,e,tp,tc) then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cm.eqfun(g,e,tp,tc)
	local ec=g:GetFirst()
	return rsop.Equip(e,ec,tc)
end 
function cm.repfilter(c,tp)
	return c:IsFaceup() and rswk.IsSet(c)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end


