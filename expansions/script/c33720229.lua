--[[
飞空神秘大鱼
Giant Airfish of Mystery
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_ANNOUNCE|CATEGORY_DAMAGE|CATEGORY_SPECIAL_SUMMON|CATEGORY_TOGRAVE|CATEGORY_DECKDES|CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetRelevantTimings()
	e1:HOPT()
	e1:SetFunctions(nil,aux.RevealSelfCost(),s.target,s.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
end
if not s.DEFAULT_CODES_TABLE then
	s.DEFAULT_CODES_TABLE = {13179332,20129614,13039848,68075840,32012841,49563947,62397231,38955728,92377303,51126152,25833572,26746975}
end

if not s.STRING_INVALID_AND_RETRY then
	s.STRING_INVALID_AND_RETRY = {}
	for i=1,3 do
		table.insert(s.STRING_INVALID_AND_RETRY,aux.Stringid(id,i))
	end
end

local STRING_INVALID_AND_ESCAPE = aux.Stringid(id,11)
local STRING_ASK_OPPONENT 		= aux.Stringid(id,12)
local STRING_SHOW_X 			= aux.Stringid(id,13)

local FLAG_TOTAL_DECLARED_LEVEL = id

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local actct=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
		local dlvct=Duel.PlayerHasFlagEffect(tp,FLAG_TOTAL_DECLARED_LEVEL) and Duel.GetFlagEffectLabel(tp,FLAG_TOTAL_DECLARED_LEVEL) or 0
		local X=actct-dlvct
		return X>0
	end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,700)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,4200)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3300)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3300)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,nil,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,c,1,nil,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,c,1,nil,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local actct=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
	local dlvct=Duel.PlayerHasFlagEffect(tp,FLAG_TOTAL_DECLARED_LEVEL) and Duel.GetFlagEffectLabel(tp,FLAG_TOTAL_DECLARED_LEVEL) or 0
	local X=math.max(0,actct-dlvct)
	
	if X==0 then return end
	
	if X<6 then
		s.announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_XYZ|TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	else
		if X>12 then
			s.announce_filter={TYPE_SPELL,OPCODE_ISTYPE}
		else
			s.announce_filter={TYPE_MONSTER|TYPE_SPELL,TYPE_XYZ|TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
		end
	end
	
	local max_tries=3
	local code,typ,lv,atk,def=0,0,0,0,0
	local escape=0
	while escape<max_tries do
		Duel.Hint(HINT_SELECTMSG,tp,STRING_SHOW_X)
		Duel.AnnounceNumber(tp,X)
		
		escape=escape+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
		typ,lv,atk,def=Duel.ReadCard(ac,CARDDATA_TYPE,CARDDATA_LEVEL,CARDDATA_ATTACK,CARDDATA_DEFENSE)
		if typ&TYPE_MONSTER>0 and lv~=X then
			if escape<max_tries then
				Duel.SelectOption(tp,s.STRING_INVALID_AND_RETRY[max_tries-escape])
			else
				Duel.SelectOption(tp,STRING_INVALID_AND_ESCAPE)
				code=s.DEFAULT_CODES_TABLE[X]
				typ,lv,atk,def=Duel.ReadCard(code,CARDDATA_TYPE,CARDDATA_LEVEL,CARDDATA_ATTACK,CARDDATA_DEFENSE)
			end
		else
			code=ac
			escape=max_tries
		end
	end
	
	if typ&TYPE_MONSTER>0 then
		if not Duel.PlayerHasFlagEffect(tp,FLAG_TOTAL_DECLARED_LEVEL) then
			Duel.RegisterFlagEffect(tp,FLAG_TOTAL_DECLARED_LEVEL,0,0,0)
		end
		Duel.UpdateFlagEffectLabel(tp,FLAG_TOTAL_DECLARED_LEVEL,lv)
	end
	
	local dam=typ&TYPE_SPELL>0 and 4200 or X*700
	if Duel.Damage(tp,dam,REASON_EFFECT)==0 then return end
	
	local c=e:GetHandler()
	local objection=Duel.SelectYesNo(1-tp,STRING_ASK_OPPONENT)
	if not objection then
		if typ&TYPE_MONSTER>0 then
			if c:IsRelateToChain() and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetValue(code)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD)
				c:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_LEVEL)
				e2:SetValue(lv)
				c:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(atk)
				c:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e4:SetValue(def)
				c:RegisterEffect(e4,true)
				c:CopyEffect(code,RESET_EVENT|RESETS_STANDARD,1)
			end
			Duel.SpecialSummonComplete()
		else
			local tc=Duel.CreateToken(tp,code)
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
			Duel.ClearTargetCard()
			tc:CreateEffectRelation(te)
			local target=te:GetTarget()
			e:SetProperty(te:GetProperty())
			if target then target(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				for tg in aux.Next(g) do
					tg:CreateEffectRelation(te)
				end
			end
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if g then
				for tg in aux.Next(g) do
					tg:ReleaseEffectRelation(te)
				end
			end
			
			if c:IsRelateToChain() then
				Duel.SendtoGrave(c,REASON_EFFECT)
			end
		end
		
	else
		local deck=Duel.GetDeck(tp)
		Duel.ConfirmCards(1-tp,deck)
		local g=deck:Filter(Card.IsCode,nil,code)
		local togycheck=false
		if #g>0 then
			local tg=g:Filter(Card.IsAbleToGrave,nil)
			if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT,1-tp)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
				togycheck=true
				Duel.Damage(1-tp,3300,REASON_EFFECT)
			end
		end
		if not togycheck then
			if Duel.Damage(tp,3300,REASON_EFFECT)>0 then
				Duel.BreakEffect()
				Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end