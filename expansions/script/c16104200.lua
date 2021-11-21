--Orth Saints
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m,cm=rk.set(16104200)
if rkch then return end
rkch=cm
function rkch.PenTri(c,code,cost)-- Tribute Summon From Pendulum-Zone
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,code)
	if cost then
		e1:SetCost(cost)
	end
	e1:SetCondition(cm.PenTriCondition1)
	e1:SetTarget(cm.PenTriTarget)
	e1:SetOperation(cm.PenTriOp)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,code)
	if cost then
		e2:SetCost(cost)
	end
	e2:SetCondition(cm.PenTriCondition2)
	e2:SetTarget(cm.PenTriTarget)
	e2:SetOperation(cm.PenTriOp)
	c:RegisterEffect(e2)
	return e1,e2
end
function rkch.PenSpLimit(c,flag)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xccd) and not c:IsSetCard(0xccb)
end
function cm.PenTriCondition1(e,tp)
	return Duel.GetFlagEffect(tp,16104242)==0
end
function cm.PenTriCondition2(e,tp)
	return Duel.GetFlagEffect(tp,16104242)>0
end
function cm.PenTriTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local minc,maxc=c:GetTributeRequirement()
	if chk==0 then return Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_ADVANCE,c) and Duel.CheckTribute(c,minc,maxc) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,tp,LOCATION_PZONE)
end
function cm.PenTriOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local minc,maxc=c:GetTributeRequirement()
	if not c:IsRelateToEffect(e) or not Duel.CheckTribute(c,minc,maxc) or not Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_ADVANCE,c) then return end
	local SummonCheck=Duel.CheckTribute(c,minc,maxc)
	if SummonCheck then
		Duel.Summon(tp,c,true,nil,1)
	end
end
function rkch.GainEffect(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYING) 
	e1:SetCountLimit(1)
	e1:SetCondition(cm.gecon)
	e1:SetOperation(cm.geop)
	c:RegisterEffect(e1)
	e1:SetLabel(code)
	return e1
end 
function cm.gecon(e,tp,eg)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:GetPreviousControler()~=tp and c:GetFlagEffect(e:GetLabel())==0
end
function cm.geop(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,e:GetLabel())
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	c:RegisterFlagEffect(e:GetLabel(),rsreset.est,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
end
function rkch.gaincon(code)
	return function(e)
		return e:GetHandler():GetFlagEffect(code)>0
	end
end
function rkch.MonzToPen(c,code,code1,flag)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(code1)
	if flag==true then
		e2:SetOperation(cm.MontoPenop)
	else
		e2:SetOperation(cm.MonToPenOp2)
	end
	c:RegisterEffect(e2)
end
function cm.MontoPenop(e,tp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:IsLocation(LOCATION_DECK) then return false end
	if not c:IsPreviousLocation(LOCATION_MZONE) then return end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden() and c:CheckUniqueOnField(tp) then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local g=Group.FromCards(c)
		g=g:Select(tp,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,false)
		c:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function cm.MonToPenOp2(e,tp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:IsLocation(LOCATION_DECK) then return false end
	if not c:IsPreviousLocation(LOCATION_MZONE) then return end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden() and c:CheckUniqueOnField(tp) then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			local g=Group.FromCards(c)
			g=g:Select(tp,1,1,nil)
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			c:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	end
end
function rkch.PenAdd(c,deslist,codelist,functionlist,flag)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(table.unpack(deslist)))
	if flag==true then
		e:SetType(EFFECT_TYPE_QUICK_O)
	else
		e:SetType(EFFECT_TYPE_IGNITION)
	end
	e:SetRange(LOCATION_PZONE)
	e:SetCode(EVENT_FREE_CHAIN) 
	e:SetCountLimit(table.unpack(codelist))
	for i=1,4 do
			if functionlist[i] and aux.GetValueType(functionlist[i])~="function" then
				error(string.format("the %d Param of functionlist must be func",i),2)
			end
			if functionlist[i] and i==1 then
				e:SetCost(functionlist[i])
			end
			if functionlist[i] and i==2 then
				e:SetCondition(functionlist[i])
			end
			if functionlist[i] and i==3 then
				e:SetTarget(functionlist[i])
			elseif i==3 then
				e:SetTarget(cm.AddTarget)
			end
			if functionlist[i] and i==4 then
				e:SetOperation(functionlist[i])
			elseif i==4 then
				e:SetOperation(cm.AddOp)
			end
	end

	c:RegisterEffect(e)
	return e
end
function cm.AddFilter(c)
	return c:IsSetCard(0xccd) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.AddTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.AddFilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,nil)
end
function cm.AddOp(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.AddFilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.DoubleFilter(c)
	return rk.check(c,"DAIOU") or c:IsSetCard(0xccd)
end
function rkch.DoubleTriFun(c,tc,reset,filter)
	tc = tc or c
	local tg = aux.TargetBoolFunction(cm.DoubleFilter) 
	if filter then tg = aux.TargetBoolFunction(filter) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	if reset then
		e1:SetReset(reset)
	end
	e1:SetValue(tg)
	tc:RegisterEffect(e1)
	return e1
end 
--------------------------------------
if not cm then return end
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=rkch.PenSpLimit(c,true)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"sp","de,dsp",nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SUMMON_SUCCESS)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=rkch.DoubleTriFun(c)
	local e5=rkch.MonzToPen(c,m,EVENT_LEAVE_FIELD,true)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xccd) and rscf.spfilter2()(c,e,tp) and not c:IsCode(m)
end
function cm.spop(e,tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e13=Effect.CreateEffect(c)
			e13:SetType(EFFECT_TYPE_SINGLE)
			e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e13:SetReset(RESET_EVENT+RESETS_STANDARD)
			e13:SetValue(1)
			tc:RegisterEffect(e13,true)
			local e14=e13:Clone()
			e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e14,true)
			local e15=e13:Clone()
			e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e15,true)
			local e15=e13:Clone()
			e15:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e15,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.thfilter(c)
	return c:IsSetCard(0xccd) and not c:IsCode(m) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
