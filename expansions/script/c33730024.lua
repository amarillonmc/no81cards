--键★断片 - 「奇迹」的栞 / Frammenti K.E.Y - Shiori dei Miracoli
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+33730024)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--excavate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.exccon)
	e4:SetTarget(s.exctg)
	e4:SetOperation(s.excop)
	c:RegisterEffect(e4)
	local e4x=Effect.CreateEffect(c)
	e4x:SetDescription(aux.Stringid(id,1))
	e4x:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4x:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4x:SetCode(EVENT_TO_GRAVE)
	e4x:SetTarget(s.exctg)
	e4x:SetOperation(s.excop)
	c:RegisterEffect(e4x)
end
s.water_aqua_key_monsters = true

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and ev==SEQ_DECKBOTTOM and r&REASON_REVEAL>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA))
end

function s.exccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.exctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
end
function s.excop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if #g>0 then
		Duel.DisableShuffleCheck()
		local opt=Duel.SelectOption(p,aux.Stringid(id,2),aux.Stringid(id,3))
		Duel.SortDecktop(p,p,#g)
		if opt~=0 then
			for i=1,#g do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
	end
end