--彩虹小队·特种干员-霜华
function c79029447.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2)  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029447.zcost)
	e1:SetTarget(c79029447.ztg)
	e1:SetOperation(c79029447.zop)
	c:RegisterEffect(e1)  
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa900))
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,7540108)
	e3:SetCondition(c79029447.thcon)
	e3:SetTarget(c79029447.thtg)
	e3:SetOperation(c79029447.thop)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+79029447)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c79029447.datg)
	e4:SetOperation(c79029447.daop)
	c:RegisterEffect(e4)   
end
function c79029447.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Debug.Message("放置迎宾踏垫只是第一步，如何把猎物引向踏垫才是值得考虑的事。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029447,0))
end
function c79029447.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,0)>0 end
end
function c79029447.zop(e,tp,eg,ep,ev,re,r,rp)
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local seq=math.log(bit.rshift(dis,16),2)
	e:SetLabel(seq)
	Debug.Message("迎宾踏垫已设置。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029447,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029447.spcon)
	e1:SetOperation(c79029447.spop)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local flag=Duel.GetFlagEffectLabel(tp,79029447)
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,79029447,0,0,1,0,0)
	else
	Duel.SetFlagEffectLabel(tp,79029447,0)
	end
end
function c79029447.fil(c,seq)
	return c:GetSequence()==seq and c:IsAbleToHand()
end
function c79029447.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(c79029447.fil,1,nil,seq) then return end 
	local tc=eg:GetFirst()
	local flag=Duel.GetFlagEffectLabel(tp,79029447)
	return eg:Filter(Card.IsControler,nil,1-tp):IsExists(c79029447.fil,1,nil,seq)  and flag~=nil  
end
function c79029447.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffectLabel(tp,79029447)
	if flag==0 then
	Debug.Message("我们准备好迎接客人了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029447,2))
	Duel.Hint(HINT_CARD,0,79029447)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local seq=e:GetLabel()
	local xg=eg:Filter(Card.IsControler,nil,1-tp):Filter(c79029447.fil,nil,seq)
	local tc=xg:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+79029447,e,0,0,tp,0)
	Duel.SetFlagEffectLabel(tp,79029447,flag+1)
	end
	e:Reset()
end  
function c79029447.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029447.thfilter(c)
	return c:IsSetCard(0xc90e) and c:IsAbleToHand()
end
function c79029447.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029447.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029447.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("永远记得未雨绸缪。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029447,4))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029447.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029447.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
end
function c79029447.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Debug.Message("是时候看看这些计划的效果了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029447,3))
	Duel.CalculateDamage(c,tc)
end















