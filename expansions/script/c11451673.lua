--风雨追随者 岑苍
--22.07.03
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,m-40,aux.FilterBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),1,true,true)
	local e10=aux.AddContactFusionProcedure(c,cm.cfilter,LOCATION_REMOVED,0,cm.tdcfop(c))
	local con=e10:GetCondition()
	local op=e10:GetOperation()
	e10:SetCondition(function(e,...)
		local tp=e:GetHandlerPlayer()
		return Duel.GetFlagEffect(tp,11451631)==0 and con(e,...)
	end)
	e10:SetOperation(function(e,tp,...) 
		local ph=Duel.GetCurrentPhase()
		if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
		Duel.RegisterFlagEffect(tp,11451631,RESET_PHASE+ph,0,1) 
		op(e,tp,...)
	end)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	--c:RegisterEffect(e0)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
end
function cm.tdcfop(c)
	return function(g)
				if #g==0 then return end
				local tp=c:GetControler()
				local dg=g:Filter(Card.IsAbleToHandAsCost,nil)
				local te=Duel.IsPlayerAffectedByEffect(tp,11451674)
				local cg=g:Filter(Card.IsFacedown,nil)
				if te and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(11451674,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
					local rg=dg:Select(tp,1,1,nil)
					g:Sub(rg)
					Duel.SendtoHand(rg,nil,REASON_COST)
					Duel.ConfirmCards(1-tp,rg)
					te:UseCountLimit(tp)
				end
				Duel.SendtoDeck(g,nil,2,REASON_COST)
				if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
			end
end
function cm.cfilter(c)
	return (c:IsFusionCode(m-40) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end