--澄炎龙 极霜克利希斯
local this,id,ofs=GetID()
function this.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand and des
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,id-200000)
	e3:SetTarget(this.thdtg) 
	e3:SetOperation(this.thdop) 
	c:RegisterEffect(e3) 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id-100000)
	e1:SetCondition(this.spcon)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(this.ntval)
	c:RegisterEffect(e2)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id)
	e4:SetCondition(this.descon)
	e4:SetTarget(this.destg)
	e4:SetOperation(this.desop)
	c:RegisterEffect(e4)
end
function this.tsrfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x6567) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end 
function this.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.tsrfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)  
end 
function this.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(this.tsrfil),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)  
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
			Duel.Destroy(c,REASON_EFFECT)   
		end   
	end  
end 
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function this.synfilter(c,g)
	return c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function this.fselect(g,tp)
	return Duel.IsExistingMatchingCard(this.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function this.cfilter(c,e)
	return c==e:GetHandler()
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		local checkflag=false 
		if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then 
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			checkflag=true
		end
		local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,fg)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mg=fg:SelectSubGroup(tp,this.fselect,false,2,#fg,tp)
			if mg:IsExists(this.cfilter,1,nil,e) then checkflag=false end
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
		if checkflag then c:ResetFlagEffect(id) end
	end
end
function this.ntval(e,c)
	return e:GetHandler():GetFlagEffect(id)>0
end
function this.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function this.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function this.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
