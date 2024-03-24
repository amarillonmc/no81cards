if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_DISABLED)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)if s.chain_solving then s.chain_solving=false end end)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetOperation(s.reset)
		Duel.RegisterEffect(ge3,0)
		s.checkg=Group.CreateGroup()
		s.checkg:KeepAlive()
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetLabelObject(s.checkg)
		ge4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetLabelObject():GetCount()>0 end)
		ge4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if e:GetLabelObject():GetCount()>0 then
				Duel.ConfirmCards(Duel.GetTurnPlayer(),e:GetLabelObject())
				Duel.ConfirmCards(1-Duel.GetTurnPlayer(),e:GetLabelObject())
				if e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,Duel.GetTurnPlayer()):GetCount()>0 then Duel.ShuffleHand(Duel.GetTurnPlayer()) end if e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,1-Duel.GetTurnPlayer()):GetCount()>0 then Duel.ShuffleHand(1-Duel.GetTurnPlayer()) end if e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsControler,nil,Duel.GetTurnPlayer()):GetCount()>0 then Duel.ShuffleDeck(Duel.GetTurnPlayer()) end if e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsControler,nil,1-Duel.GetTurnPlayer()):GetCount()>0 then Duel.ShuffleDeck(1-Duel.GetTurnPlayer()) end
				for k,v in pairs({Duel.IsPlayerAffectedByEffect(0,6)}) do if v:GetOwner()==c then v:SetValue(s.value2)end end
				e:GetLabelObject():Clear()
			end
		end)
		Duel.RegisterEffect(ge4,0)
		local f=Card.RegisterEffect
		Card.RegisterEffect=function(tc,te,bool)
			if te:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O) and not te:IsHasType(EFFECT_TYPE_SINGLE) and te:GetProperty()&EFFECT_FLAG_UNCOPYABLE==0 then
				local tg=te:GetTarget()
				if not tg then tg=aux.TRUE end
				te:SetTarget(s.tg(te,tg,c))
			end
			return f(tc,te,bool)
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) then s.chain_solving=true end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	if s.chain_solving then s.chain_solving=false Duel.RegisterFlagEffect(rp,id,RESET_PHASE+SNNM.GetCurrentPhase(),0,1) end
end
function s.handcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.tg(te,tg,c)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then
					local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
					if tg(e,tp,eg,ep,ev,re,r,rp,0,false) and res and tre:GetHandler():GetOriginalCode()==id then
						s.checkg:AddCard(e:GetHandler())
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD)
						e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						e1:SetCode(EFFECT_CANNOT_ACTIVATE)
						e1:SetTargetRange(1,1)
						e1:SetLabelObject(e:GetHandler())
						e1:SetValue(s.value1)
						e1:SetReset(RESET_PHASE+SNNM.GetCurrentPhase())
						Duel.RegisterEffect(e1,tp)
						return false
					end
					return tg(e,tp,eg,ep,ev,re,r,rp,0)
				end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function s.value1(e,re,tp)
	 return re:GetHandler()==e:GetLabelObject()
end
function s.value2(e,re,tp)
	 return re:GetHandler():GetOriginalCodeRule()==e:GetLabelObject():GetOriginalCodeRule()
end
