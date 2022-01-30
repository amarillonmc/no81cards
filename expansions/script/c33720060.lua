-- 强欲与馄饨之壶 / Giara dell'Ingordigia
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if ep==p or ep==PLAYER_ALL then
			for i=1,ev do
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)>0 end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		local pmax=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		if pmax==0 then return end
		local numtab={1}
		for i=2,pmax do
			if Duel.IsPlayerCanDraw(1-tp,i) then
				table.insert(numtab,i)
			else
				break
			end
		end
		local d=(#numtab==1) and 1 or Duel.AnnounceNumber(1-tp,table.unpack(numtab))
		Duel.Draw(1-tp,d,REASON_EFFECT)
	else
		Duel.Recover(tp,3000,REASON_EFFECT)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.trcon)
	e2:SetOperation(s.trop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.GetTurnCount()==e:GetLabel()
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetFlagEffect(1-tp,id)*4000
	if val>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Recover(tp,val,REASON_EFFECT)
	end
	e:Reset()
end