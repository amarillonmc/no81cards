--[[
宏大之殇
Wound of Sincerity
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Apply the following effects for the rest of the Duel.
	● Each time you draw a card(s): Add the top card and bottom card of your Deck to your hand.
	● Each time you would add a card(s) from your Deck to your hand (except by drawing), banish the top half of your Deck, face-down, (rounded-up) before that.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_TURN_END)
		ge4:OPT()
		ge4:SetOperation(s.resetop)
		Duel.RegisterEffect(ge4,0)
		
		s.IsAbleToHandMod=false
		s.IsAbleToHandChecked=false
		s.IsAbleToHandGroupTab={}
		local _IsAbleToHand, _SelectMatchingCard, _GetFirstMatchingCard, _Group, _GroupFilter, _GroupSelect, _GroupFilterSelect, _GetFirst, _GroupRemove =
		Card.IsAbleToHand, Duel.SelectMatchingCard, Duel.GetFirstMatchingCard, Duel.GetMatchingGroup, Group.Filter, Group.Select, Group.FilterSelect, Group.GetFirst, Group.RemoveCard
		
		function Card.IsAbleToHand(c,...)
			local x={...}
			local p = #x>0 and x[1] or self_reference_tp
			--Debug.Message(s.IsAbleToHandMod==true)
			--Debug.Message(Duel.PlayerHasFlagEffect(p,id))
			if s.IsAbleToHandMod==true and Duel.PlayerHasFlagEffect(p,id) then
				s.IsAbleToHandChecked=true
				--Debug.Message(s.IsAbleToHandChecked)
				local rg=Duel.GetDecktopGroup(p,math.ceil(Duel.GetDeckCount(p)/2)):Filter(Card.IsAbleToRemove,nil,p,POS_FACEDOWN)
				if rg:IsContains(c) then
					--Debug.Message(c:GetOriginalCode())
					return false
				end
			end
			return _IsAbleToHand(c,...) 
		end
		
		function Duel.SelectMatchingCard(selp,f,tp,loc1,loc2,min,max,exc,...)
			--Debug.Message(1)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			if s.IsAbleToHandMod==true then
				local prev=s.IsAbleToHandChecked
				local g=_Group(f,tp,loc1,loc2,exc,...)
				local thchk=s.IsAbleToHandChecked
				s.IsAbleToHandChecked=prev
				--Debug.Message(thchk)
				if thchk and #g<min then
					s.IsAbleToHandMod=false
					local ng=_Group(f,tp,loc1,loc2,exc,...)
					s.IsAbleToHandMod=handmod
					return ng
				end
			end
			local g=_SelectMatchingCard(selp,f,tp,loc1,loc2,min,max,exc,...)
			s.IsAbleToHandMod=handmod
			return g
		end
		
		function Duel.GetFirstMatchingCard(f,tp,loc1,loc2,exc,...)
			--Debug.Message(2)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			if s.IsAbleToHandMod==true then
				local prev=s.IsAbleToHandChecked
				local g=_Group(f,tp,loc1,loc2,exc,...)
				local thchk=s.IsAbleToHandChecked
				s.IsAbleToHandChecked=prev
				if thchk and #g<min then
					s.IsAbleToHandMod=false
					local ng=_Group(f,tp,loc1,loc2,exc,...)
					s.IsAbleToHandMod=handmod
					return ng:GetFirst()
				end
			end
			local g= _GetFirstMatchingCard(f,tp,loc1,loc2,exc,...)
			s.IsAbleToHandMod=handmod
			return g
		end
		
		function Duel.GetMatchingGroup(f,tp,loc1,loc2,exc,...)
			--Debug.Message(3)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			local prev=s.IsAbleToHandChecked
			local g=_Group(f,tp,loc1,loc2,exc,...)
			local thchk=s.IsAbleToHandChecked
			s.IsAbleToHandChecked=prev
			if thchk and s.IsAbleToHandMod==true then
				s.IsAbleToHandMod=false
				local ng=_Group(f,tp,loc1,loc2,exc,...)
				s.IsAbleToHandMod=handmod
				ng:KeepAlive()
				s.IsAbleToHandGroupTab[g]=ng
			end
			s.IsAbleToHandMod=handmod
			return g
		end
		
		function Group.Filter(g,f,exc,...)
			--Debug.Message(4)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			local prev=s.IsAbleToHandChecked
			local g=_GroupFilter(g,f,exc,...)
			local thchk=s.IsAbleToHandChecked
			s.IsAbleToHandChecked=prev
			if thchk and s.IsAbleToHandMod==true then
				s.IsAbleToHandMod=false
				local ng=_GroupFilter(g,f,exc,...)
				s.IsAbleToHandMod=handmod
				ng:KeepAlive()
				s.IsAbleToHandGroupTab[g]=ng
			end
			s.IsAbleToHandMod=handmod
			return g
		end
		
		function Group.Select(g,tp,min,max,exc)
			--Debug.Message(5)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			local thchk=s.IsAbleToHandGroupTab[g]~=nil
			if thchk then
				local ng=s.IsAbleToHandGroupTab[g]:Clone()
				s.IsAbleToHandGroupTab[g]:DeleteGroup()
				s.IsAbleToHandGroupTab[g]=nil
				if s.IsAbleToHandMod==true and #g<min then
					s.IsAbleToHandMod=handmod
					return ng
				end
			end
			s.IsAbleToHandMod=handmod
			return _GroupSelect(g,tp,min,max,exc)
		end
		
		function Group.FilterSelect(g,f,tp,min,max,exc,...)
			--Debug.Message(6)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			local thchk1=s.IsAbleToHandGroupTab[g]~=nil
			local thchk3=s.IsAbleToHandMod==true and #g<min
			if thchk1 then
				local ng=s.IsAbleToHandGroupTab[g]:Clone()
				s.IsAbleToHandGroupTab[g]:DeleteGroup()
				s.IsAbleToHandGroupTab[g]=nil
				if thchk3 then
					s.IsAbleToHandMod=handmod
					return ng
				end
			elseif thchk3 then
				s.IsAbleToHandMod=false
				local prev=s.IsAbleToHandChecked
				local ng=_GroupFilter(g,f,exc,...)
				s.IsAbleToHandMod=handmod
				local thchk2=s.IsAbleToHandChecked
				s.IsAbleToHandChecked=prev
				if thchk2 then
					return ng
				end
			end
			s.IsAbleToHandMod=handmod
			return _GroupFilterSelect(g,f,tp,min,max,exc,...)
		end
		
		function Group.GetFirst(g)
			local handmod=s.IsAbleToHandMod
			local thchk=s.IsAbleToHandGroupTab[g]~=nil
			if thchk then
				if handmod~=0 then s.IsAbleToHandMod=true end
				local ng=s.IsAbleToHandGroupTab[g]:Clone()
				s.IsAbleToHandGroupTab[g]:DeleteGroup()
				s.IsAbleToHandGroupTab[g]=nil
				if s.IsAbleToHandMod==true and #g==0 then
					s.IsAbleToHandMod=handmod
					return _GetFirst(ng)
				end
			end
			s.IsAbleToHandMod=handmod
			return _GetFirst(g)
		end
		
		function Group.RemoveCard(g,c)
			local handmod=s.IsAbleToHandMod
			if handmod~=0 then s.IsAbleToHandMod=true end
			local thchk=s.IsAbleToHandGroupTab[g]~=nil
			if thchk and s.IsAbleToHandMod==true and not g:IsContains(c) then
				s.IsAbleToHandMod=handmod
				local ng=s.IsAbleToHandGroupTab[g]
				if ng:IsContains(c) then
					return _GroupRemove(ng,c)
				end
			end
			s.IsAbleToHandMod=handmod
			return _GroupRemove(g,c)
		end
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	aux.ClearTableRecursive(s.IsAbleToHandGroupTab)
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:Desc(2,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DRAW)
	e1:SetFunctions(s.tgcon,nil,s.tgtg,s.tgop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:Desc(3,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetLabelObject(e1)
	e2:SetTarget(s.reptg)
	e2:SetValue(aux.FALSE)
	Duel.RegisterEffect(e2,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDeck(tp)
	if #g>=2 then
		Duel.DisableShuffleCheck()
		local rg=Duel.GetDecktopGroup(tp,math.ceil(Duel.GetDeckCount(tp)/2)):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
		if #rg>0 then
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
		g=Duel.GetDeck(tp)
		local tg=g:GetMinGroup(Card.GetSequence)+g:GetMaxGroup(Card.GetSequence)
		s.IsAbleToHandMod=0
		tg=tg:Filter(Card.IsAbleToHand,nil)
		s.IsAbleToHandMod=false
		if #tg==2 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end

function s.repfilter(c,p,e)
	return c:IsControler(p) and c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_HAND and c:IsAbleToHand() and c:GetReasonEffect()~=e
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	s.IsAbleToHandMod=0
	local g=eg:Filter(s.repfilter,nil,tp,e:GetLabelObject())
	s.IsAbleToHandMod=false
	local rg=Duel.GetDecktopGroup(tp,math.ceil(Duel.GetDeckCount(tp)/2)):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	--Debug.Message(#g)
	--Debug.Message(#rg)
	if chk==0 then return #g>0 and #rg>0 end
	Duel.DisableShuffleCheck()
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	return false
end