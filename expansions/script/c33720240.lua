--[[
【月】【背景音台】动物朋友圆舞曲
【Ｒ】Anifriends Rondo
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_DOUBLESIDED then
	Duel.LoadScript("glitchylib_doublesided.lua")
end
if not TYPE_SOUNDSTAGE then
	Duel.LoadScript("glitchylib_soundstage.lua")
end
function s.initial_effect(c)
	aux.AddDoubleSidedProc(c,SIDE_REVERSE,id-1,id)
	aux.AddSoundStageProc(c,c:Activation(),id,3,0)
	--[[During your End Phase, declare up to 7 "Anifriends" card names (min. 1), and apply 1 of these effects (You cannot check cards in the GYs when this effect applies.):]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:OPT()
	e1:SetOperation(s.declare)
	c:RegisterEffect(e1)
end

local STRING_ASK_ANOTHER_NAME			= aux.Stringid(id,1)
local STRING_ASK_SUCCESSFUL				= aux.Stringid(id,2)
local STRING_SHUFFLE_OPPO				= aux.Stringid(id,3)
local STRING_SHUFFLE_SELF				= aux.Stringid(id,4)

--E1
function s.thfilter(c,codes)
	return c:IsCode(table.unpack(codes)) and c:IsAbleToHand()
end
function s.declare(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local DeclaredNames={}
	local UpperLimit=7
	s.announce_filter={ARCHE_ANIFRIENDS,OPCODE_ISSETCARD}
	for i=1,UpperLimit do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local code=Duel.AnnounceCard(p,table.unpack(s.announce_filter))
		table.insert(DeclaredNames,code)
		if i<UpperLimit and not Duel.SelectYesNo(p,STRING_ASK_ANOTHER_NAME) then
			break
		end
	end
	
	local ct=0
	local g=Duel.GetGY(tp)
	for i,code in ipairs(DeclaredNames) do
		local tc=g:Filter(Card.IsSequence,nil,i-1):GetFirst()
		if tc:IsCode(code) then
			ct=ct+1
		else
			break
		end
	end
	
	local dnct=#DeclaredNames
	if ct==dnct then
		local tg=g:Filter(Card.IsSequenceBelow,nil,ct-1)
		local max=#tg==1 and #tg or #tg-1
		if aux.SelectUnselectGroup(tg,e,tp,1,max,s.tdcheck,0) and Duel.SelectYesNo(p,STRING_ASK_SUCCESSFUL) then
			local tdo=aux.SelectUnselectGroup(tg,e,tp,1,max,s.tdcheck,1,tp,STRING_SHUFFLE_OPPO,s.tdcheck)
			if #tdo>0 then
				Duel.HintSelection(tdo)
				if Duel.ShuffleIntoDeck(tdo,1-tp)>0 then
					tg:Sub(tdo)
					if #tg==0 then return end
					local tds=aux.SelectUnselectGroup(tg,e,tp,1,#tg,s.tdcheck2,1,tp,STRING_SHUFFLE_SELF,s.tdcheck2)
					if #tds>0 then
						tg:Sub(tds)
						Duel.BreakEffect()
						Duel.HintSelection(tds)
						if Duel.ShuffleIntoDeck(tds,tp)>0 and #tg>0 then
							Duel.Search(tg)
						end
					end
				end	
			end
		end
	elseif ct~=dnct and aux.SelectUnselectGroup(g,e,tp,dnct,dnct,s.tdcheck3,0) then
		local tg=aux.SelectUnselectGroup(g,e,tp,dnct,dnct,s.tdcheck3,1,1-tp,HINTMSG_OPERATECARD,s.tdcheck3)
		if #tg>0 then
			local thg=aux.SelectUnselectGroup(tg,e,tp,1,#tg,s.tdcheck3,1,1-tp,HINTMSG_ATOHAND,s.tdcheck3)
			if #thg>0 and Duel.SearchAndCheck(thg,nil,1-tp) then
				tg:Sub(thg)
				if #tg>0 then
					Duel.SendtoDeck(tg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT,1-tp)
				end
			end
		end
	end
end
function s.tdcheck(g,e,tp,mg,c)
	local cg=mg:Clone()
	local tg=g:Filter(Card.IsAbleToDeck,nil)
	cg:Sub(tg)
	return #tg>0 and (#mg==1 or aux.SelectUnselectGroup(cg,e,tp,#cg,#cg,s.tdcheck2,0))
end
function s.tdcheck2(g,e,tp,mg,c)
	local cg=g:Clone()
	local tg=cg:Filter(Card.IsAbleToDeck,nil)
	cg:Sub(tg)
	return #tg>0 and (#cg==0 or cg:FilterCount(Card.IsAbleToHand,nil)==#cg)
end
function s.tdcheck3(g,e,tp,mg,c)
	local cg=g:Clone()
	local tg=cg:Filter(Card.IsAbleToHand,nil)
	cg:Sub(tg)
	return #cg==0 or cg:FilterCount(Card.IsAbleToDeck,nil)==#cg
end