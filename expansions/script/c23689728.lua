--无限起动 克瑞舍巨人
local s,id,o=GetID()
function s.initial_effect(c)
	--
	if c:GetOriginalCode()==id then

	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--link summon
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.xyzcon)
	e1:SetTarget(s.xyztg)
	e1:SetOperation(s.xyzop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(id)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)

	end
	
end
function s.matfilter(c)
	return c:IsLinkSetCard(0x127) and not c:IsLinkType(TYPE_LINK)
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function s.condition(e)
	return e:GetHandler():IsOriginalSetCard(0x127)
end
function s.filter(c)
	return c:IsSetCard(0x127) and not c:IsCode(id) and c:IsType(TYPE_XYZ)
end
function s.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return (te:GetValue()==id and not tc:IsHasEffect(id))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==id+1 and tc:IsHasEffect(id)) 
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		local c=e:GetHandler()
		--
		s.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(s.actarget)
		Duel.RegisterEffect(ge0,0)
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				local con=eff:GetCondition()
				if effect:IsHasType(EFFECT_TYPE_IGNITION) 
				   or (con and effect:IsHasType(EFFECT_TYPE_QUICK_O) and effect:GetCode()==EVENT_FREE_CHAIN) then
					eff:SetValue(id+1)
					--effect edit
					local eff2=effect:Clone()
					--spell speed 2
					if eff2:IsHasType(EFFECT_TYPE_IGNITION) then
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					--spell speed 2
					if con and eff2:IsHasType(EFFECT_TYPE_QUICK_O) and eff2:GetCode()==EVENT_FREE_CHAIN then
						eff2:SetCondition(
						function(e,tp,eg,ep,ev,re,r,rp)
							Infinitrack_GetCurrentPhase=Duel.GetCurrentPhase
							Duel.GetCurrentPhase=function() return PHASE_MAIN1 end
							local Infinitrack_boolean=con(e,tp,eg,ep,ev,re,r,rp)
							Duel.GetCurrentPhase=Infinitrack_GetCurrentPhase
							return Infinitrack_boolean
						end)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					eff2:SetValue(id)
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			return 
		end

		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(id,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
