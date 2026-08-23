--新式魔厨的料理帮厨
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(s.reg)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetCountLimit(1,id+o)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--ritual level
	--[[local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetCode(EFFECT_RITUAL_LEVEL)
	e21:SetValue(s.rlevel)
	c:RegisterEffect(e21)]]
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.dscon)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_DECK)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(s.pzcon)
	e5:SetTarget(s.pztg)
	e5:SetOperation(s.pzop)
	c:RegisterEffect(e5)
	--Pzone ritual material
	if not s.globle_check then
		--chain check
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(s.chainop)
		Duel.RegisterEffect(e1,0)
		--
		s.globle_check=true
		s.globle_ritual_check=false
		local _IsCanBeRitualMaterial=Card.IsCanBeRitualMaterial
		Card.IsCanBeRitualMaterial=(function(c,sc)
			if sc:GetFlagEffect(id+1)~=0 then
				return c:IsLocation(LOCATION_PZONE) or _IsCanBeRitualMaterial(c,sc)
			end
			return _IsCanBeRitualMaterial(c,sc)
		end)
		local _GetRitualLevel=Card.GetRitualLevel
		Card.GetRitualLevel=(function(gc,rc)
			if rc:GetFlagEffect(id+1)~=0 and gc:IsLocation(LOCATION_PZONE) then 
				local lv=aux.GetCappedLevel(gc)
				local clv=rc:GetLevel()
				return (lv<<16)+clv
				--return 3 
			end
			return _GetRitualLevel(gc,rc)
		end)
		local _SetMaterial=Card.SetMaterial
		Card.SetMaterial=(function(c,g)
			if c:GetFlagEffect(id+1)~=0 and Duel.GetFlagEffect(tp,id+2)~=0 and g:FilterCount(Card.IsLocation,nil,LOCATION_PZONE) then 
				Duel.Hint(HINT_CARD,0,id)
				local te=Duel.IsPlayerAffectedByEffect(tp,id)
				te:UseCountLimit(tp)
			end
			return _SetMaterial(c,g)
		end)
		Nouvelle_hack_ritual_check=aux.RitualUltimateFilter
		function Auxiliary.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
			if Duel.IsPlayerAffectedByEffect(tp,id) and c:IsSetCard(0x196) and c:IsLevelBelow(3) then
				local exg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_PZONE,0,nil,c)
				if exg:GetCount()>0 then
					local g=Group.__add(exg,m1)
					c:RegisterFlagEffect(id+1,RESET_EVENT+RESET_CHAIN,0,1)
					if Duel.GetFlagEffect(tp,id+1)~=0 then
						c:RegisterFlagEffect(id,RESET_EVENT+RESET_CHAIN,0,1)
						Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_CHAIN,0,1)
					end
					--[[local _IsCanBeRitualMaterial=Card.IsCanBeRitualMaterial
					Card.IsCanBeRitualMaterial=(function(c,sc)
						return c:IsLocation(LOCATION_PZONE) or _IsCanBeRitualMaterial(c,sc)
					end)]]
					--[[local _GetLevel=Card.GetLevel
					Card.GetLevel=(function(c)
						if c:IsLocation(LOCATION_PZONE) then return c:GetOriginalLevel() end
						return _GetLevel(c)
					end)]]
					--[[local _GetRitualLevel=Card.GetRitualLevel
					Card.GetRitualLevel=(function(gc,rc)
						if rc==c and gc:IsLocation(LOCATION_PZONE) then 
							local lv=gc:GetOriginalLevel()
							local clv=rc:GetLevel()
							return (lv<<16)+clv
							--return 3 
						end
						return _GetRitualLevel(gc,rc)
					end)]]
					s.globle_ritual_check=true
					local res=Nouvelle_hack_ritual_check(c,filter,e,tp,g,m2,level_function,greater_or_equal,chk)
					s.globle_ritual_check=false
					if Duel.GetFlagEffect(tp,id+2)==0 then c:ResetFlagEffect(id+1) end
					return res
				end
			end
			return Nouvelle_hack_ritual_check(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
		end
		Nouvelle_hack_ritual_mat_filter=Group.Filter
		function Group.Filter(group,filter,card_or_group_or_nil,...)
			if not s.globle_ritual_check and card_or_group_or_nil and aux.GetValueType(card_or_group_or_nil)=="Card" and card_or_group_or_nil:GetFlagEffect(id)~=0 and Duel.GetFlagEffect(card_or_group_or_nil:GetControler(),id+1)~=0 and Duel.GetFlagEffect(card_or_group_or_nil:GetControler(),id)~=0 then
				--Debug.Message("72")
				--Duel.Hint(HINT_MESSAGE,0,1190)
				local exg=Group.CreateGroup()
				exg=Duel.GetMatchingGroup(s.filter0,card_or_group_or_nil:GetControler(),LOCATION_PZONE,0,nil,card_or_group_or_nil)
				group:Merge(exg)
				card_or_group_or_nil:RegisterFlagEffect(id+1,RESET_EVENT+RESET_CHAIN,0,1)
				Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESET_CHAIN,0,1)
			end
			return Nouvelle_hack_ritual_mat_filter(group,filter,card_or_group_or_nil,...)
		end
	end
end
function s.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsSetCard(0x196) and c:IsLevelBelow(3) then
		local clv=c:GetOriginalLevel()
		return (lv<<16)+clv
	else return lv end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id+1,RESET_EVENT+RESET_CHAIN,0,1)
end
function s.filter0(c,rc)
	--[[Debug.Message("--")
	if bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 then Debug.Message("11") end
	if c:IsLevelAbove(1) then Debug.Message("22") end
	if c:IsCanBeRitualMaterial(rc) then Debug.Message("33") end]]
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsLevelAbove(1) 
	--and c:IsCanBeRitualMaterial(rc)
end
function s.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.thfilter(c)
	return c:IsCode(41773061) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)]]
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_RELEASE) and c:IsLocation(LOCATION_EXTRA)
		and c:IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return c:IsCode(id)
end
