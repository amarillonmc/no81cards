--[[
命·运·游·戏
D.E.S.T.I.N.Y.
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If this is the only card in your hand: You can Special Summon it, and if you do, you can add 1 card from your Deck to your hand.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(s.condition,s.cost,s.target,s.operation)
	c:RegisterEffect(e1)
	--[[Each time you would draw a card(s), you can declare 1 card name for each card you would draw instead, and if you do, your opponent looks at your Deck, and for each declared name, they add 1
	card with that name from your Deck to your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(id)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:Desc(3,id)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.sumfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.sumfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_FLIPSUMMON,s.sumfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_ATTACK,s.sumfilter)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.forbid)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.regop_move)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MSET)
		ge2:SetOperation(s.regop_set)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SSET)
		ge3:SetOperation(s.regop_set)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_CHANGE_POS)
		ge4:SetOperation(s.regop_set)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.GlobalEffect()
		ge5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_BE_MATERIAL)
		ge5:SetOperation(s.regop_set)
		Duel.RegisterEffect(ge5,0)
	
		local _Draw = Duel.Draw
		
		function Duel.Draw(p,val,r)
			if Duel.IsPlayerAffectedByEffect(p,id) and not Duel.PlayerHasFlagEffect(p,id+100)
				and Duel.GetCustomActivityCount(id,p,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(id,p,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(id,p,ACTIVITY_SPSUMMON)+Duel.GetCustomActivityCount(id,p,ACTIVITY_FLIPSUMMON)+Duel.GetCustomActivityCount(id,p,ACTIVITY_ATTACK)==0 then
				s.applyRestrictions(c,p)
				
				local g=Duel.GetDeck(p)
				local tg=g:Filter(s.thfilter,nil,1-p)
				if #tg>=val and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
					local insert_or = false
					local valid_codes={}
					local announced_codes={}
					for tc in aux.Next(tg) do
						local codes={tc:GetCode()}
						for _,code in ipairs(codes) do
							table.insert(valid_codes,code)
							table.insert(valid_codes,OPCODE_ISCODE)
							if insert_or then
								table.insert(valid_codes,OPCODE_OR)
							else
								insert_or=true
							end
						end
					end
					for i=1,val do
						Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CODE)
						local ac=Duel.AnnounceCard(p,table.unpack(valid_codes))
						table.insert(announced_codes,ac)
					end
					Duel.ConfirmCards(1-p,g)
					local tohand=Group.CreateGroup()
					for _,code in ipairs(announced_codes) do
						local thg=Duel.Select(HINTMSG_ATOHAND,false,1-p,s.thfilter,p,LOCATION_DECK,0,1,1,nil,1-p,code)
						if #thg>0 then
							tohand:Merge(thg)
						end
					end
					if #tohand>0 and Duel.SendtoHand(tohand,p,REASON_EFFECT,1-p)>0 then
						local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
						for tc in aux.Next(og) do
							local p=tc:GetControler()
							local codes={tc:GetCode()}
							for _,code in ipairs(codes) do
								Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,code)
							end
						end
					end
					return 0
				end
			end
			return _Draw(p,val,r)
		end
	end
end
function s.chainfilter(re,rp,cid)
	local codes={re:GetHandler():GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(rp,id,code) then
			return true
		end
	end
	return false
end
function s.sumfilter(c)
	if c:IsFacedown() then return false end
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(rp,id,code) then
			return true
		end
	end
	return false
end
function s.thfilter(c,p,code)
	return Duel.IsPlayerCanSendtoHand(p,c) and (not code or c:IsCode(code))
end
function s.forbid(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if Duel.PlayerHasFlagEffect(p,id+200) then
			local g=Duel.Group(s.bantg,p,LOCATION_ALL,0,nil,p)
			local g2=Duel.Group(s.unbantg,p,LOCATION_ALL,0,g)
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(id,RESET_PHASE|PHASE_END,0,1)
				local e4=Effect.CreateEffect(tc)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EFFECT_FORBIDDEN)
				e4:SetLabelObject(e)
				e4:SetReset(RESET_PHASE|PHASE_END)
				tc:RegisterEffect(e4)
			end
			for tc in aux.Next(g2) do
				tc:ResetFlagEffect(id)
				local eset={tc:IsHasEffect(EFFECT_FORBIDDEN)}
				for _,ce in ipairs(eset) do
					if ce:GetLabelObject()==e then
						ce:Reset()
					end
				end
			end
		end
	end
end
function s.bantg(c,p)
	if c:HasFlagEffect(id) then return false end
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(p,id,code) then
			return false
		end
	end
	return true
end
function s.unbantg(c,p)
	if not c:HasFlagEffect(id) then return false end
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(p,id,code) then
			return true
		end
	end
	return false
end

function s.movefilter(c,p)
	return c:IsOnField() and c:IsFaceup() and not c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==p
end
function s.regop_move(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if not Duel.PlayerHasFlagEffect(p,id+100) then
			local g=eg:Filter(s.movefilter,nil,p)
			for tc in aux.Next(g) do
				local codes={tc:GetCode()}
				for _,code in ipairs(codes) do
					if not Duel.PlayerHasFlagEffectLabel(p,id,code) then
						Duel.RegisterFlagEffect(p,id+100,RESET_PHASE|PHASE_END,0,1)
					end
				end
			end
		end
	end
end
function s.regop_set(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if not Duel.PlayerHasFlagEffect(p,id+100) then
			local g=eg:Filter(Card.IsReasonPlayer,nil,p)
			for tc in aux.Next(g) do
				local codes={tc:GetCode()}
				for _,code in ipairs(codes) do
					if not Duel.PlayerHasFlagEffectLabel(p,id,code) then
						Duel.RegisterFlagEffect(p,id+100,RESET_PHASE|PHASE_END,0,1)
					end
				end
			end
		end
	end
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetHandCount(tp)==1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.PlayerHasFlagEffect(tp,id+100)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_FLIPSUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_ATTACK)==0 end
	local c=e:GetHandler()
	s.applyRestrictions(c,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExists(false,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,STRING_ASK_TO_HAND) then
		local tg=Duel.Select(HINTMSG_ATOHAND,false,tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
			local tc=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_HAND):GetFirst()
			if tc then
				local p=tc:GetControler()
				local codes={tc:GetCode()}
				for _,code in ipairs(codes) do
					Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,code)
				end
			end
		end
	end
end

--E3
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetDrawCount(tp)
	local g=Duel.GetDeck(p)
	local tg=g:Filter(s.thfilter,nil,1-tp)
	if chk==0 then return Duel.IsTurnPlayer(tp) and aux.IsPlayerCanNormalDraw(tp) and ct>0 and #tg>=ct
		and not Duel.PlayerHasFlagEffect(tp,id+100)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_FLIPSUMMON)+Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsPlayerCanNormalDraw(tp) or not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	s.applyRestrictions(e:GetHandler(),tp)
	local val=Duel.GetDrawCount(tp)
	aux.GiveUpNormalDraw(e,tp)
	local g=Duel.GetDeck(tp)
	local tg=g:Filter(s.thfilter,nil,1-tp)
	local insert_or = false
	local valid_codes={}
	local announced_codes={}
	for tc in aux.Next(tg) do
		local codes={tc:GetCode()}
		for _,code in ipairs(codes) do
			table.insert(valid_codes,code)
			table.insert(valid_codes,OPCODE_ISCODE)
			if insert_or then
				table.insert(valid_codes,OPCODE_OR)
			else
				insert_or=true
			end
		end
	end
	for i=1,val do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(valid_codes))
		table.insert(announced_codes,ac)
	end
	Duel.ConfirmCards(1-tp,g)
	local tohand=Group.CreateGroup()
	for _,code in ipairs(announced_codes) do
		local thg=Duel.Select(HINTMSG_ATOHAND,false,1-tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,1-tp,code)
		if #thg>0 then
			tohand:Merge(thg)
		end
	end
	if #tohand>0 and Duel.SendtoHand(tohand,tp,REASON_EFFECT,1-tp)>0 then
		local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_HAND)
		for tc in aux.Next(og) do
			local p=tc:GetControler()
			local codes={tc:GetCode()}
			for _,code in ipairs(codes) do
				Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,code)
			end
		end
	end
end

function s.applyRestrictions(c,tp)
	Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE|PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclim)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.sumlim)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTarget(s.sumlim)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	Duel.RegisterEffect(e6,tp)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	Duel.RegisterEffect(e7,tp)
	aux.CannotBeEDMaterial(c,nil,nil,true,RESET_PHASE|PHASE_END,c,EFFECT_FLAG_IGNORE_IMMUNE,nil,nil,EFFECT_TYPE_FIELD,LOCATION_MZONE,s.sumlim,tp)
end
function s.aclim(e,re,rp)
	local codes={re:GetHandler():GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(rp,id,code) then
			return false
		end
	end
	return true
end
function s.sumlim(e,c,sump,sumtype,sumpos,targetp,se)
	local codes={c:GetCode()}
	for _,code in ipairs(codes) do
		if Duel.PlayerHasFlagEffectLabel(rp,id,code) then
			return false
		end
	end
	return true
end