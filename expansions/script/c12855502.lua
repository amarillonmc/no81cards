--封璇击·合姬
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,aux.tdcfop(c))
	--disable zone(monster effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(570)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.ztg)
	e2:SetOperation(s.zop)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.distg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1274)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+100)
	e3:SetTarget(s.chtg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(s.splimit)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3a7a) and c:IsFusionType(TYPE_MONSTER) 
		and c:IsLevel(4) and (not sg or not sg:IsExists(Card.IsCode,1,c,c:GetCode()))
end
function s.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function s.zop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.distg(e,c)
	return c==e:GetHandler():GetBattleTarget() or c==e:GetHandler()
end
function s.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a7a) and c:IsLevelBelow(4) and c:GetSequence()<5
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and s.chfilter(chkc) end
	if chk==0 then return c:GetSequence()<5 and Duel.IsExistingTarget(s.chfilter,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,s.chfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:GetSequence()>5 or c:GetSequence()>5 then return end
	Duel.SwapSequence(c,tc)
end