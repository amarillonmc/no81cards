--观测
local s, id = GetID()

function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c, s.mfilter, s.ffilter, 2, 2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop2)
	c:RegisterEffect(e2)
end

function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,1)
end

function s.ffilter(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x3226)
end

function s.rmfilter(c)
	return c:IsSetCard(0x3226) and c:GetType()==TYPE_SPELL and not c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD+TYPE_QUICKPLAY+TYPE_RITUAL)
		and c:IsAbleToRemove()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		s.apply_effect(tc,e,tp)
	end
end

function s.apply_effect(tc,e,tp)
	if not tc then return end
	
	local te=tc:GetActivateEffect()
	if te then
		local condition=te:GetCondition()
		local target=te:GetTarget()
		
		if (not condition or condition(te,tp,Group.CreateGroup(),PLAYER_NONE,0,te,REASON_EFFECT,PLAYER_NONE)) then
			
			Duel.ClearTargetCard()
		
			
			local g=Group.CreateGroup()
			if target then
				target(te,tp,Group.CreateGroup(),PLAYER_NONE,0,te,REASON_EFFECT,PLAYER_NONE,1)
				g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					for etc in aux.Next(g) do
						etc:CreateEffectRelation(te)
					end
				end
			end
			
   
			local op=te:GetOperation()
			if op then
				op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,te,REASON_EFFECT,PLAYER_NONE)
			end
			
			if g then
				for etc in aux.Next(g) do
					etc:ReleaseEffectRelation(te)
				end
			end
		end
	end
end

function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	
	local og=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g=og:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	
	e:SetLabelObject(tc)
	
	Duel.SendtoGrave(g,REASON_COST)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(s.droplater)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
	
	if tc and tc:IsSetCard(0x3226) and tc:IsType(TYPE_SPELL)
			and not tc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD+TYPE_QUICKPLAY+TYPE_RITUAL) then
			
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				s.apply_effect(tc,e,tp)
			end
	end
end

function s.droplater(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)	
	e:Reset()
end