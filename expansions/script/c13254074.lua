--元始飞球造物·魔鬼·球体形
local m=13254074
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,13254036,cm.ffilter,1,60,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--[[wip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	]]

	elements={{"tama_elements",{{TAMA_ELEMENT_CHAOS,2},{TAMA_ELEMENT_MANA,2},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
	
end
function cm.ffilter(c,fc,sub,mg,sg)
	local el={{TAMA_ELEMENT_LIFE,2}}
	local g=Group.CreateGroup()
	if sg then
		g=sg:Clone()
		g:AddCard(c)
	end
	return tama.tamas_isExistElements(c,el) and (not sg or tama.tamas_isCanSelectElementsForAbove(g,el))
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if rg:GetCount()>=3 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:Select(tp,3,3,nil)
		Duel.Release(sg,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_CHAOS,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(aux.tgoval)
	Duel.RegisterEffect(e3,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
