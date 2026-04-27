local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111245,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW) -- 添加抽卡类别
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end

function s.spfilter(c,e,tp)
	if not c:IsCode(8662794) then return false end
	local ok=false
	for p=0,1 do
		local zone=Duel.GetLinkedZone(p)&0xff
		ok=ok or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone))
	end
	return ok
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) -- 设置抽卡操作信息
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone={}
	local flag={}
	for p=0,1 do
		zone[p]=Duel.GetLinkedZone(p)&0xff
		local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
		flag[p]=(~flag_tmp)&0x7f
	end
	local ft1=Duel.GetLocationCount(0,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[0])
	local ft2=Duel.GetLocationCount(1,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1])
	if ft1+ft2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc then
			local avail_zone=0
			for p=0,1 do
				if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p,zone[p]) then
					avail_zone=avail_zone|(flag[p]<<(p==tp and 0 or 16))
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~avail_zone))
			local sump=0
			if sel_zone&0xff>0 then
				sump=tp
			else
				sump=1-tp
				sel_zone=sel_zone>>16
			end
			if Duel.SpecialSummon(tc,0,tp,sump,false,false,POS_FACEUP,sel_zone)~=0 then
				-- 成功特殊召唤后抽1张卡
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
		and rp==1-tp and c:IsPreviousControler(tp)
end
function s.cfilter(c)
	return c:IsCode(8662794)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end