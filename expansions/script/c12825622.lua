Chikichikibanban={}
chiki=Chikichikibanban
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYBERS=RACE_CYBERSE
--Lua by 空鸽（Fix.REIKAI）
--铳影自肃
function Chikichikibanban.c4a71Limit(c)
	--spsummon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(Chikichikibanban.c4a71Limitspcost)
	e1:SetOperation(Chikichikibanban.c4a71Limitspcop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(Chikichikibanban.c4a71Limitsplimit2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(12825602,ACTIVITY_SPSUMMON,Chikichikibanban.counterfilter)
end
function Chikichikibanban.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function Chikichikibanban.c4a71Limitspcost(e,c,tp)
	return Duel.GetCustomActivityCount(12825602,tp,ACTIVITY_SPSUMMON)==0
end
function Chikichikibanban.c4a71Limitspcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Chikichikibanban.c4a71Limitsplimit)
	Duel.RegisterEffect(e1,tp)
end
function Chikichikibanban.c4a71Limitsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function Chikichikibanban.c4a71Limitsplimit2(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x4a76)
end
--铳影通用回收
function Chikichikibanban.c4a71tohand(c,tg,op,category)
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local category=category 
	if not category then category=CATEGORY_TOHAND end
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1110)
	e1:SetCategory(category)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end
function Chikichikibanban.c4a71tohandthfilter(c)
	return c:IsSetCard(0x4a76) and c:IsAbleToHand()
end
function Chikichikibanban.c4a71tohandthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Chikichikibanban.c4a71tohandthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function Chikichikibanban.c4a71tohandthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Chikichikibanban.c4a71tohandthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsCode(12825601) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,2) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

--铳影通用康型效果
function Chikichikibanban.c4a71kang(c,con,tg,op,category,cardcode,message,excode)
	local con=con 
	if not con then con=Chikichikibanban.c4a71kangdiscon end
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local cardcode=cardcode 
	local excode=excode
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,cardcode)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1)
	e2:SetCost(Chikichikibanban.c4a71kangcost)
	e2:SetCondition(Chikichikibanban.c4a71kangdiscon2(con,excode))
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(Chikichikibanban.sumsuc)
	c:RegisterEffect(e3)
end

function Chikichikibanban.c4a71kang2(c,con,tg,op,category,cardcode,message,excode)
	local con=con 
	if not con then con=Chikichikibanban.c4a71kangdiscon end
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local cardcode=cardcode 
	local excode=excode
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_ACTIVATE_CONDITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,cardcode)
	e1:SetCost(Chikichikibanban.c4a71kangcost0)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,cardcode+100)
	e2:SetCondition(Chikichikibanban.c4a71kangdiscon2(con,excode))
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(Chikichikibanban.sumsuc)
	c:RegisterEffect(e3)
end
function Chikichikibanban.c4a71kangcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetCode())==0 or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.GetFlagEffect(tp,e:GetHandler():GetCode())==0 then
		Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function Chikichikibanban.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():GetFlagEffect(12825612)~=0 then return end
	c:RegisterFlagEffect(12825612,RESET_PHASE+PHASE_END,0,1)
end

function Chikichikibanban.c4a71kangdiscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(12825612)>0 
end
function Chikichikibanban.c4a71kangdiscon2(con,excode)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,excode)
			end
end

--铳影通用升阶效果(代写)
function Chikichikibanban.c4a71rankup(c,f1,f2,cardcode)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(2)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,cardcode+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(Chikichikibanban.c4a71rankuptarget(f1,f2))
	e1:SetOperation(Chikichikibanban.c4a71rankupactivate(f1,f2))
	c:RegisterEffect(e1)
end
function Chikichikibanban.c4a71rankupfilter1(c,e,tp,f1,f2)
	return (not f1 or f1(c)) and Duel.IsExistingMatchingCard(Chikichikibanban.c4a71rankupfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,f2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function Chikichikibanban.c4a71rankupfilter2(c,e,tp,mc,f2)
	return (not f2 or f2(c)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function Chikichikibanban.c4a71rankuptarget(f1,f2)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and Chikichikibanban.c4a71rankupfilter1(chkc,e,tp,f1,f2) end
				if chk==0 then return Duel.IsExistingTarget(Chikichikibanban.c4a71rankupfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,f1,f2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				Duel.SelectTarget(tp,Chikichikibanban.c4a71rankupfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,f1,f2)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			end
end
function Chikichikibanban.c4a71rankupactivate(f1,f2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local tc=Duel.GetFirstTarget()
				if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
				if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,Chikichikibanban.c4a71rankupfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,f2)
				local sc=g:GetFirst()
				if sc then
					local mg=tc:GetOverlayGroup()
					if mg:GetCount()~=0 then
						Duel.Overlay(sc,mg)
					end
					sc:SetMaterial(Group.FromCards(tc))
					Duel.Overlay(sc,Group.FromCards(tc))
					Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
					sc:CompleteProcedure()
					if c:IsRelateToEffect(e) then
						c:CancelToGrave()
						Duel.Overlay(sc,Group.FromCards(c))
					end
				end
			end
end


--通用墓地启动效果
function Chikichikibanban.chikione(c,location,cost,con,tg,op,category,cardcode,message)
	local location=location
	if not location then location=LOCATION_MZONE end
	local cost=cost 
	local con=con
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local message=message
	local cardcode=cardcode 
	local category=category
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	if category then
		e1:SetCategory(category)
	end
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,cardcode)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(location)
	if con then
		e1:SetCondition(con)
	end
	if cost then 
		e1:SetCost(cost)
	end
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end

function Chikichikibanban.chikiav(c,propery,cost,con,tg,op,category,cardcode,message)
	local propery=propery
	local cost=cost 
	local con=con
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local category=category
	local cardcode=cardcode 
	local message=message
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(category)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,cardcode+EFFECT_COUNT_CODE_OATH)
	if propery then
		e1:SetProperty(propery)
	end
	if con then
		e1:SetCondition(con)
	end
	if cost then 
		e1:SetCost(cost)
	end
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end