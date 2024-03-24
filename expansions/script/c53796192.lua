if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(0xff)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetLabelObject(e2)
	e3:SetCondition(s.effcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.effcon)
	e4:SetTarget(s.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(id)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(s.effcon)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge2_2=ge1:Clone()
		ge2_2:SetCode(EVENT_DESTROYED)
		Duel.RegisterEffect(ge2_2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return s.check or s.mvcheck or s.effcheck end)
		ge3:SetOperation(s.resetop)
		Duel.RegisterEffect(ge3,0)
		local f1=Card.RegisterEffect
		Card.RegisterEffect=function(tc,te,bool)
			if te:IsHasType(EFFECT_TYPE_CONTINUOUS) and te:GetProperty()&EFFECT_FLAG_UNCOPYABLE==0 then
				local op=te:GetOperation()
				te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					s.check=true
					if op then op(e,tp,eg,ep,ev,re,r,rp) end
				end)
			end
			if te:IsActivated() then
				local con,cost,tg=te:GetCondition(),te:GetCost(),te:GetTarget()
				if not con then con=aux.TRUE end
				if not cost then cost=aux.TRUE end
				if not tg then tg=aux.TRUE end
				te:SetCondition(function(...)
					s.effcheck=true
					local res=con(...)
					s.effcheck=false
					return res
				end)
				te:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						s.effcheck=true
						local res=cost(e,tp,eg,ep,ev,re,r,rp,0)
						s.effcheck=false
						return res
					end
					s.effcheck=true
					cost(e,tp,eg,ep,ev,re,r,rp,1)
					s.effcheck=false
					return res
				end)
				te:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
					if chk==0 then
						s.effcheck=true
						local res=tg(e,tp,eg,ep,ev,re,r,rp,0)
						s.effcheck=false
						return res
					end
					s.effcheck=true
					tg(e,tp,eg,ep,ev,re,r,rp,1)
					s.effcheck=false
					return res
				end)
				local sop=te:GetOperation()
				te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					s.effcheck=true
					if sop then sop(e,tp,eg,ep,ev,re,r,rp) end
				end)
			end
			return f1(tc,te,bool)
		end
		local f2=Duel.RegisterEffect
		Duel.RegisterEffect=function(te,tp)
			if te:IsHasType(EFFECT_TYPE_CONTINUOUS) and te:GetProperty()&EFFECT_FLAG_UNCOPYABLE==0 then
				local op=te:GetOperation()
				te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					s.check=true
					if op then op(e,tp,eg,ep,ev,re,r,rp) end
				end)
			end
			return f2(te,tp)
		end
		local f3=Duel.AdjustAll
		Duel.AdjustAll=function()
			s.adjcheck=true
			local res=f3()
			s.adjcheck=false
			return res
		end
		local f4=Duel.Readjust
		Duel.Readjust=function()
			s.adjcheck=true
			local res=f4()
			s.adjcheck=false
			return res
		end
		local f5=Duel.AdjustInstantly
		Duel.AdjustInstantly=function(...)
			s.adjcheck=true
			local res=f5(...)
			s.adjcheck=false
			return res
		end
		local f6=Duel.MoveToField
		Duel.MoveToField=function(mc,...)
			local res=f6(mc,...)
			if s.check then sc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
			return res
		end
		local f7=Duel.Equip
		Duel.MoveToField=function(p,ec,...)
			local res=f7(p,ec,...)
			if s.check then ec:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
			return res
		end
		local f8=Duel.SSet
		Duel.SSet=function(ssp,ssc,...)
			local res=f8(ssp,ssc,...)
			if s.check then ssc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
			return res
		end
		local f9=Duel.MoveSequence
		Duel.MoveSequence=function(mvc,seq)
			local cseq=mvc:GetSequence()
			local res=f9(mvc,seq)
			if s.check and mvc:IsLocation(LOCATION_SZONE) and ((seq>4 and cseq<5) or (seq<5 and cseq>4)) then mvc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
			return res
		end
		local originalEffCheckFunctions={}
		local EffCheckFunctionsName={"IsAbleToHand","IsAbleToDeck","IsAbleToGrave","IsPlayerCanSendtoHand","IsPlayerCanSendtoDeck","IsPlayerCanSendtoGrave","IsPlayerCanDiscardDeck","IsPlayerCanDraw"}
		for i,funcName in ipairs(EffCheckFunctionsName) do
			local tab=Duel
			if i<4 then tab=Card end
			originalEffCheckFunctions[funcName]=tab[funcName]
			tab[funcName]=function(other,sc,...)
				if s.check then sc:RegisterFlagEffect(id,RESET_EVENT+0xfc0000,0,1) end
				return originalEffCheckFunctions[funcName](other,sc,...) and (not Duel.IsPlayerAffectedByEffect(0,id) or s.effcheck)
			end
		end
		local originalDuelFunctions={}
		local DuelFunctionsName={"Summon","SpecialSummonRule","SynchroSummon","XyzSummon","LinkSummon","MSet"}
		for _,funcName in ipairs(DuelFunctionsName) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(other,sc,...)
				if s.check then sc:RegisterFlagEffect(id,RESET_EVENT+0xfc0000,0,1) end
				return originalDuelFunctions[funcName](other,sc,...)
			end
		end
	end
end
function s.cfilter(c,re)
	return c:GetLocation()~=c:GetPreviousLocation() and ((c:IsReason(REASON_EFFECT+REASON_REDIRECT) and (not re or re:IsActivated())) or (c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT) and not c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT):IsActivated()))
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	s.mvcheck=true
	for tc in aux.Next(eg:Filter(s.cfilter,nil,re)) do tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	s.effcheck=false
	if s.mvcheck then s.mvcheck=false else s.check=false end
end
function s.ovfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsCanOverlay()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x3c) and s.ovfilter(chkc) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.IsExistingTarget(s.ovfilter,tp,0x3c,0x3c,1,nil) then return false end
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(TYPE_XYZ)
		e:GetHandler():RegisterEffect(e0)
		local res=e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		e0:Reset()
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.ovfilter,tp,0x3c,0x3c,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if not c:IsRelateToEffect(e) then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_XYZ)
	e0:SetReset(RESET_EVENT+0xfc0000)
	c:RegisterEffect(e0)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then Duel.Overlay(c,tg) end
end
function s.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.efilter(e,c,rp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0 and not re:IsActivated()
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:IsActivated() and c:IsType(TYPE_MONSTER)
end
