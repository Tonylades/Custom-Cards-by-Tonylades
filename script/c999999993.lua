--Signer Warrior
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon procedure
	Synchro.AddProcedure(c,s.tfilter,1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
	--Special Summoning condition
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetCountLimit(1,{1,id})
	c:RegisterEffect(e1)
	--Place Signal Counters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.ctcs)
	e1:SetCountLimit(1,{2,id})
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(s.ctval)
    c:RegisterEffect(e3) 
end
s.listed_series={0x1017}
s.material_setcode=0x1017
s.counter_place_list={COUNTER_SIGNAL}
--summon proc
function s.spfilter1(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(5) and c:IsFaceup()
		and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true,true)
end
function s.spfilter2(c,tp)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_TUNER) and c:IsLocation(LOCATION_GRAVE)
		and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true,true)
end
function s.rescon(sg,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
		and sg:FilterCount(s.spfilter1,nil,tp)==1
		and sg:FilterCount(s.spfilter2,nil,tp)==1
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_GRAVE,0,nil,tp)
	local g=g1:Clone()
	g:Merge(g2)
	return #g1>0 and #g2>0 and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local rg=g1:Clone()
	rg:Merge(g2)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup() 
end
--Signal Counter
function s.ctval(e,c)
    return c:GetCounter(COUNTER_SIGNAL)
end
function s.ctfilter(c)
	return c:IsSetCard(0x1017) and c:IsMonster()
end
function s.ctcs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chk==0 then return c:HasLevel() end
	local lv=c:GetLevel()
	local opt
	if e:GetLabelObject():GetLevel() then end
	if c:IsRelateToEffect(e) then
			   if c:IsRelateToEffect(e) and c:IsFaceup()
			   and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			   c:AddCounter(COUNTER_SIGNAL,e:GetLabelObject():GetLevel())
			end
		end
end
        
		 


