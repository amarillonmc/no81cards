--[[
夺舍
Possession
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If exactly 1 Fusion Monster is Special Summoned to your opponent's field: Take damage equal to its ATK, and if you do, send to the GY, from your Deck and/or Extra Deck, a group of monsters
	that matches the Fusion Material requirements of that monster, and if you do that, take control of it.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_SPSUMMON_SUCCESS,s.cfilter,id)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE|CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.operation
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		
		local _MustMaterialCheck = Auxiliary.MustMaterialCheck

		function Auxiliary.MustMaterialCheck(...)
			if aux.PossessionCheck then return true end
			return _MustMaterialCheck(...)
		end
	
	end
end
function s.cfilter(c,_,tp,eg)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsControler(1-tp) and (not eg or not eg:IsExists(s.cfilter,1,c,nil,tp,nil))
end

--E1
function s.filter(c,tp,g)
	return s.cfilter(c,nil,tp,nil) and c:IsAttackAbove(1) and c:IsControlerCanBeChanged() and c:CheckFusionMaterial(g,nil,PLAYER_NONE,true)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	aux.PossessionCheck=true
	local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
	if chk==0 then
		local res=#g>0 and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) and eg:IsExists(s.filter,1,nil,tp,g)
		aux.PossessionCheck=false
		return res
	end
	local tg=eg:Filter(s.filter,nil,tp,g)
	aux.PossessionCheck=false
	local tc
	if #tg==1 then
		tc=tg:GetFirst()
	else
		Duel.HintMessage(tp,HINTMSG_FACEUP)
		tg=tg:Select(tp,1,1,nil)
		tc=tg:GetFirst()
	end
	Duel.HintSelection(tg)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,tp,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK|LOCATION_EXTRA)
	Duel.SetCardOperationInfo(tc,CATEGORY_CONTROL)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or not s.cfilter(tc,nil,tp,nil) or not tc:IsAttackAbove(1) then return end
	local dam=Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
	if dam>0 then
		local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
		if #g==0 then return end
		aux.PossessionCheck=true
		local mg=Duel.SelectFusionMaterial(tp,tc,g,nil,PLAYER_NONE)
		aux.PossessionCheck=false
		if #mg>0 and Duel.SendtoGraveAndCheck(mg) and tc:IsRelateToChain() then
			Duel.GetControl(tc,tp)
		end
	end
end