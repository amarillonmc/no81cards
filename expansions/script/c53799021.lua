local m=53799021
local cm=_G["c"..m]
cm.name="束缚丝线而操纵人形的魔女"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_TOKEN) and Duel.GetTurnPlayer()==1-tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
	local b1=g:IsExists(Card.IsControler,1,nil,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,nil,nil,nil,POS_FACEUP,tp)
	local b2=g:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsPlayerCanSpecialSummonMonster(1-tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,nil,nil,nil,POS_FACEUP,1-tp)
	if chk==0 then return Duel.GetMZoneCount(tp,g:Filter(Card.IsControler,nil,tp))>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,eg:GetCount(),0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN):Filter(Card.IsDestructable,nil,e)
	local rac={}
	local att={}
	local lv={}
	local cont={}
	for tc in aux.Next(g) do
		table.insert(rac,tc:GetRace())
		table.insert(att,tc:GetAttribute())
		table.insert(lv,tc:GetLevel())
		table.insert(cont,tc:GetControler())
	end
	if Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		for i=1,#g do
			local p=cont[i]
			if Duel.IsPlayerCanSpecialSummonMonster(p,m+1,0,TYPES_TOKEN_MONSTER,0,0,lv[i],rac[i],att[i],POS_FACEUP,p) and Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
				local token=Duel.CreateToken(p,m+1)
				if Duel.SpecialSummonStep(token,0,p,p,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					token:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_LEAVE_FIELD)
					e2:SetOperation(cm.damop)
					token:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CHANGE_LEVEL)
					e3:SetValue(lv[i])
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					token:RegisterEffect(e3,true)
					local e4=e3:Clone()
					e4:SetCode(EFFECT_CHANGE_RACE)
					e4:SetValue(rac[i])
					token:RegisterEffect(e4,true)
					local e5=e3:Clone()
					e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e5:SetValue(att[i])
					token:RegisterEffect(e5,true)
					local e6=Effect.CreateEffect(c)
					e6:SetType(EFFECT_TYPE_FIELD)
					e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
					e6:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
					e6:SetRange(LOCATION_EXTRA)
					e6:SetTargetRange(0,LOCATION_MZONE)
					e6:SetValue(cm.matval)
					local e7=Effect.CreateEffect(c)
					e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
					e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
					e7:SetTargetRange(0,LOCATION_EXTRA)
					e7:SetRange(LOCATION_MZONE)
					e7:SetReset(RESET_EVENT+RESETS_STANDARD)
					e7:SetLabelObject(e6)
					e7:SetTarget(cm.eftg)
					token:RegisterEffect(e7,true)
				end
			end
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function cm.eftg(e,c)
	return c:IsType(TYPE_LINK)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(e:GetHandler():GetPreviousControler(),800,REASON_EFFECT)
	e:Reset()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(9) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
