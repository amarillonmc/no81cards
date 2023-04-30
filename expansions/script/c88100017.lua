--放光水晶阵·潜能
function c88100017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x30ea))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88100017,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88100017.drcon)
	e4:SetTarget(c88100017.drtg)
	e4:SetOperation(c88100017.drop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88100017,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c88100017.sccon)
	e5:SetTarget(c88100017.sctg)
	e5:SetOperation(c88100017.scop)
	c:RegisterEffect(e5)
	if not c88100017.global_check then
		c88100017.global_check=true
		c88100017[0]=0
		c88100017[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c88100017.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c88100017.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c88100017.mfilter(c)
	return c:IsSetCard(0x30ea)
end
function c88100017.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	while tc do
		if mg:IsExists(c88100017.mfilter,1,nil) and tc:IsSummonType(SUMMON_TYPE_SYNCHRO) then
			local p=tc:GetSummonPlayer()
			c88100017[p]=c88100017[p]+1
		end
		tc=eg:GetNext()
	end
end
function c88100017.clearop(e,tp,eg,ep,ev,re,r,rp)
	c88100017[0]=0
	c88100017[1]=0
end
function c88100017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c88100017[tp]>0
end
function c88100017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c88100017[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c88100017[tp])
end
function c88100017.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,c88100017[tp],REASON_EFFECT)
end
function c88100017.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x30ea) and c:IsControler(tp)
end
function c88100017.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88100017.scfilter,1,nil,tp)
end
function c88100017.filter(c)
	return c:IsLinkSummonable(nil)
end
function c88100017.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingMatchingCard(c88100017.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c88100017.scop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if sg:GetCount()>0 and Duel.IsExistingMatchingCard(c88100017.filter,tp,LOCATION_EXTRA,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(88100017,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=sg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,pg:GetFirst(),nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c88100017.filter,tp,LOCATION_EXTRA,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.LinkSummon(tp,tc,nil)
			end
		end
	elseif sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pg=sg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,pg:GetFirst(),nil)
	elseif Duel.IsExistingMatchingCard(c88100017.filter,tp,LOCATION_EXTRA,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88100017.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end