--Anti-Art-Attachment
local s,id=GetID()
s.MoJin=true
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	--不能特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	
	--场上装备效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.eqtg1)
	e2:SetOperation(s.eqop1)
	c:RegisterEffect(e2)
	
	--墓地装备效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.eqtg2)
	e3:SetOperation(s.eqop2)
	c:RegisterEffect(e3)
	
	--除外装备效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetTarget(s.eqtg3)
	e4:SetOperation(s.eqop3)
	c:RegisterEffect(e4)
end


--目标过滤器
function s.eqfilter(c,tp,loc)
	local res=false
	if loc==LOCATION_MZONE then
		res=Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c) 
	elseif loc==LOCATION_GRAVE then
		res=Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c)
	elseif loc==LOCATION_REMOVED then
		res=Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c)
	end
	return res and c:IsFaceup() and c.MoJin
end
function s.eqlimit(e,c)
	local tc=e:GetLabelObject()
	return c==tc and not c:IsDisabled()
end

--装备函数
function s.equipop(c,e,tp,tc,dam)
	if not Duel.Equip(tp,tc,c) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(c)
	tc:RegisterEffect(e1)

	if dam and not (c:IsCode(5012602) or c:IsCode(5012617)) then
		Duel.Damage(tp,3000,REASON_EFFECT)
	end
end

--场上装备效果
function s.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp,LOCATION_MZONE)
		and e:GetHandler():CheckUniqueOnField(tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if not tc then return end
	
	--装备自己
	s.equipop(tc,e,tp,c,true)
	
	--选择并装备墓地卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc)
	if #g1>0 then
		s.equipop(tc,e,tp,g1:GetFirst(),false)
	end
	
	--选择并装备除外卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,tc)
	if #g2>0 then
		s.equipop(tc,e,tp,g2:GetFirst(),false)
	end
	
	--注册当回合使用过的标记
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--墓地装备效果
function s.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp,LOCATION_GRAVE)
		and e:GetHandler():CheckUniqueOnField(tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,LOCATION_GRAVE)
	local tc=g:GetFirst()
	if not tc then return end
	
	--装备自己
	s.equipop(tc,e,tp,c,true)
	
	--选择并装备场上卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
	if #g1>0 then
		s.equipop(tc,e,tp,g1:GetFirst(),false)
	end
	
	--选择并装备除外卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,tc)
	if #g2>0 then
		s.equipop(tc,e,tp,g2:GetFirst(),false)
	end
	
	--注册当回合使用过的标记
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end

--除外装备效果
function s.eqtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+2)==0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp,LOCATION_REMOVED)
		and e:GetHandler():CheckUniqueOnField(tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.eqop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,LOCATION_REMOVED)
	local tc=g:GetFirst()
	if not tc then return end
	
	--装备自己
	s.equipop(tc,e,tp,c,true)
	
	--选择并装备场上卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
	if #g1>0 then
		s.equipop(tc,e,tp,g1:GetFirst(),false)
	end
	
	--选择并装备墓地卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc)
	if #g2>0 then
		s.equipop(tc,e,tp,g2:GetFirst(),false)
	end
	
	--注册当回合使用过的标记
	Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
end
